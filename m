Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbZHLEbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbZHLEbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZHLEbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:31:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:31386 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZHLEbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VBE0aI+gHynKUdE+IJ0GMUnxh5f2mLQbrnff32Cdfl4tnZU+1ex3avbRdppVzjYchr
         ebQuz7mMGMhYeQZAxBu2lqFCgDD3Bwvn5LtzRSvCTfeRr+khyqeHXv+voCWO6zVi7eFJ
         ZZ1TSt2F0Y31JL7ZGcT6EKk0fQpPdOulImD8Y=
Message-ID: <4A8245A0.3030409@gmail.com>
Date: Tue, 11 Aug 2009 21:31:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
CC: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends,
 but does not wakes up
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br> <20081109113332.GD6094@elf.ucw.cz> <dd18b0c30811092117mc7bd310kaac33f5b1ff0a61d@mail.gmail.com> <20081110074516.GB707@atrey.karlin.mff.cuni.cz> <8B08E6ED-5B5F-4AC0-A147-481A54ED6B55@ime.usp.br>
In-Reply-To: <8B08E6ED-5B5F-4AC0-A147-481A54ED6B55@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> Hi, Pavel and other people.
>
> I'm just resurrecting this old bug (and everybody that was involved 
> with it), as it's been quite some time now and I still have the exact 
> same problems, unfortunately. :-(
>
> (I wrote the comments below in the past year, but they are still valid).
>
> On Nov 10 2008, Pavel Machek wrote:
>>> FWIW, running radeon and s2ram
>>> gives me a successful wakeup,
>>> no delays only bluetooth-applet fails
>>> to show back up as eye candy.
>
> It seems that s2disk doesn't hang here, from a limited test, but I will
> stress test this thing a bit further to see what is happening.
>
>> So 2.6.28-rc3 actually works for you? Good ;-).
>
> You were replying to Justin, just to make sure. :-) The attributions are
> now completely messed up. :-)
>
> Funnily, Ubuntu's intrepid doesn't have s2ram (I think that I'll grab it
> from Debian for further testing).
>
> (...)
>
> If anybody has any idea on how to proceed, I would be thankful.
>
>
> Thanks, Rogério Brito.
>
Sh^t forgot about this...
Anyways at the moment seems
the powerbutton does shutdown the system, and closing the
lid suspends the machine.(in the exception for an erb error from
bluetoooth which might be causing the delay(not sure yet)
works as is(kernel= latest git a week or so old).

At the moment I'm using acpid for these functions to work.
(keep in mind /etc/acpi/has my own commands in them
not any from a dist).
As for the suspend button I did e-mail the acpid maintainer, and
it seems their might not be a sleep button on the keyboard for
a macbook(143 or whatever the number is).  but you can adjust acpid to
react accordingly.

In response to the bug your just not getting a reaction to the keyboard
while its sleeping?(maybe the s* state needs to be changed for that,
but then again I could be wrong).

Justin P. Mattock
