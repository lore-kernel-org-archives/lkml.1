Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYFKXww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYFKXww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYFKXwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:52:43 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:46525 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbYFKXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:52:42 -0400
X-IronPort-AV: E=Sophos;i="4.27,626,1204502400"; 
   d="scan'208";a="2021695"
Date: Thu, 12 Jun 2008 00:52:40 +0100 (BST)
From: Keith Roberts <keith@karsites.net>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
In-Reply-To: <485031FA.6070303@zytor.com>
Message-ID: <alpine.LFD.1.10.0806120029040.23296@www.karsites.net>
References: <311993399@web.de> <484F10A9.4030606@zytor.com> <alpine.LFD.1.10.0806112102350.18067@www.karsites.net> <485031FA.6070303@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, H. Peter Anvin wrote:

> To: Keith Roberts <keith@karsites.net>
> From: H. Peter Anvin <hpa@zytor.com>
> Subject: Re: Problems with edd
> 
> Keith Roberts wrote:
>>> 
>>> I have put in syslinux 3.70-pre16 code to print the source of this 
>>> message.  You may want to try to grab isolinux from this release and 
>>> update your CD image to get some useful debugging info out of this.
>>>
>>>     -hpa
>> 
>> Not being a kernel guru, I'm not sure how to do that hpa?
>> 
>> Where do I get isolinux from please?
>> 
>
> ftp://ftp.kernel.org/pub/linux/utils/boot/syslinux/Testing/syslinux-3.70-pre16.tar.bz2
>
>> how do I update my CD image?
>
> You will need to run mkisofs with the same options used to generate the 
> image.

OK - thankyou for that, hpa

> In a pinch, if you can point me to the original ISO I could try to doctor 
> it.

I originally got mine from:

http://mirror.switch.ch/ftp/mirror/fedora/linux/releases/9/Fedora/i386/iso/Fedora-9-i386-netinst.iso

The sha1sum is:

3b1df20ece05d64c34dd9c64400975b74eded0f2  Fedora-9-i386-netinst.iso

I have also put it on my website, just in case it gets 
updated on the mirrors:

http://www.karsites.net/fedora/9/Fedora-9-i386-netinst.iso

obviously same sha1sum ;)

The Fedora guys are following this thread now. I have put 
the link to your patch on my Fedora bug report:

https://bugzilla.redhat.com/show_bug.cgi?id=450678

I have never built an iso file before, but I'll read up on 
it. My plan was to copy the files from the F9 net-installer 
CD to my hard drive, update them with your patch, and then 
re-make the iso file and burn that back to CD-R. Would that 
work?

>> I'm willing to give this a try if it will sort out the problem.
>
> That would be useful.  This is potentially a previously unreported BIOS 
> issue which might have a straightforward workaround, so I'm eager to get 
> the data.
>
> 	-hpa

Regards

Keith
