Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbZFNT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbZFNT0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZFNT0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:26:03 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59154 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZFNT0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hhjrHtdvtZ7jWkTv8Bf0k3puLSAWQhQ4mn9iqTiq1BkWXBhFX8SetFN6QHGVQTtKgt
         mpJSk6NP11ndMLRfkn6ERJyLMKesi8Mb7vPE24Ic3QCFR2div0Uqm5x3bdhv0Q85gwZa
         /Xp33mI6PsEvpWDxn0oGmypHzJ25CXuWO+P0g=
MIME-Version: 1.0
In-Reply-To: <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
Date: Sun, 14 Jun 2009 21:26:02 +0200
Message-ID: <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       gnome-power-manager-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 7:51 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 6/13/09, Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
>> I demand that Corentin Chary may or may not have written...
>>
>>> On Sat, Jun 13, 2009 at 11:33 AM, Alan
>>> Jenkins<alan-jenkins@tuffmail.co.uk>
>>> wrote:
>> [snip]
>>>> The firmware still changes the brightness immediately.  It seems
>>>> that when g-p-m gets delayed, it responds _wrongly_. It doesn't realize
>>>> that the firmware already changed the brightness, so it changes the
>>>> brightness again.
>>
>> Should it be changing the brightness at all? I ask because every laptop
>> which
>> I've used will change the brightness without userspace being involved.
>> (Although it's possible that g-p-m might get brightness-change events from
>> some source other than that which is used to report the laptop's own
>> brightness controls...)
>
> Good point.  Google suggests it may be necessary on some other systems though.
>
> <https://lists.ubuntu.com/archives/kubuntu-bugs/2009-February/067008.html>
>
> And I was wrong before when I said g-p-m should watch the generic
> backlight interface.  It doesn't generate uevents, and in one way
> that's good, because uevents are relatively heavyweight.  So the
> brightness up / down "keypress" events are the only generic way that
> g-p-m can use to detect changes :-(.
>
> But I don't think it's important to be able to show a brightness
> pop-up.  So I'm less confident, but I still think this change should
> be reverted.
>
>> [snip]
>>> Version: 2.24.2-2ubuntu8
>>> Ok I can reproduce [the brightness being changed inappropriately from
>>> userspace].
>>
>>> I want to check if we can't fix g-p-m before reverting the patch. If
>>> there is no way to fix it, I'll revert.
>>
>> I don't see that it can ever be reliable in the face of the brightness
>> having
>> already been changed without userspace involvement short of being able to
>> tell it to report only on some/all events from some input devices.
>
> Hmm.  I think I could accept it if it only played up when thrashing
> the SSD.  So I'll try to work out exactly what happens in the other
> case I reported, in case they're not the same problem.  (This other
> problem is where I hold down "brightness down", then tap "brightness
> up" a couple of times; the first couple of taps casue a flash as the
> brightness goes first up and then down).
>
> Alan
>

CCed gnome-power-manager, as it seems to be the only userspace program
concerned.
You may be able to help us here.

You can find the complet discussion here:
http://groups.google.com/group/linux.kernel/browse_thread/thread/a7bef6cffb7c2d6b/c732f616555d5180?#c732f616555d5180


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
