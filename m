Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZFMIzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZFMIzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 04:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZFMIzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 04:55:12 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:36618 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZFMIzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 04:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h5mjsWVl9g+fmgZMsOEUo7bCeITRaAqG7L6Wf+uicKfXjlkfJVKglVcJXUgKIdMu0v
         IaEns/zqbfF8DJCmvuCMzTbErlFrOlFlInJQpyTAhPdVqLb1Z21URauL+iNBisqDguYS
         yLPM3tQXFy1/bTDdg+MhiQAfvOMU6irKL5LK0=
MIME-Version: 1.0
In-Reply-To: <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
Date: Sat, 13 Jun 2009 10:55:11 +0200
Message-ID: <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: alan-jenkins@tuffmail.co.uk
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 5:24 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 4/4/09, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> On Fri, Apr 03, 2009 at 06:57:50PM +0100, Darren Salt wrote:
>>> This maps the brightness control events to one of two keys, either
>>> KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.
>>>
>>> Some mapping has to be done due to the fact that the BIOS reports them as
>>> <base value> + <current brightness index>; the selection is done according
>>> to
>>> the sign of the change in brightness (if this is 0, no keypress is
>>> reported).
>>>
>>> (Ref.
>>> http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)
>>>
>>> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
>>
>> The reason I didn't do this is that the Eee changes the input brightness
>> in hardware, which means reporting it via the input layer as well can
>> cause a single keypress to raise the brightness by two steps - one in
>> hardware and one triggered by userland's response to the key press. I'd
>> be a little bit wary of this causing problems.
>>
>> On the other hand, the default behaviour of the acpi video driver is to
>> change the brightness itself and then also to send the even to
>> userspace, so I guess if it was going to break things it probably would
>> have done already...
>
> Actually, I think userspace has learnt to hack around it but it
> doesn't work perfectly.  I would like to request that this change be
> reverted, or otherwise improved.
>
> Before this patch (2.6.29.4), gnome-power-manager doesn't interfere
> with the brightness keys, and they work smoothly.
>
> After this patch (2.6.30-rc7), g-p-m produces a "nice" popup in the
> middle of my tiny netbook screen.  Unfortunately it can't be disabled,
> but that's not your fault :-).  The brightness controls generally work
> ok.  It doesn't jump two steps in response to one brightness keypress.
>  But:
>
> 1) If I'm thrashing the SSD.  I get jerky after-effects, where g-p-m
> seems to take too long to "catch up" with the brightness change.

There is the same "lag" problem with sound :/

> 2) If I go all the way down from full (holding down the "brightness
> down" key), and then back up a few steps.  I get a noticable flash
> where the brightness looks to go up two steps, then down one.  It's
> probably most noticable here because the step change between the
> lowest and the second lowest brightness is much more visible than any
> of the other steps.
>
I tried to install gnome-power-manager to test that, but there is no "popup".
What do I have to install to test that ? entire gnome desktop :/ ?

Thanks


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
