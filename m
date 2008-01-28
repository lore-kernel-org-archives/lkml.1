Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbYA1TP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbYA1TP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbYA1TLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:11:10 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:57256 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762431AbYA1TLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:11:08 -0500
Date: Mon, 28 Jan 2008 14:09:05 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <20080128185345.CF0A51871238@smtp03.mtu.ru>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Richard Heck <rgheck@bobjweil.com>, linux-kernel@vger.kernel.org
Message-id: <200801281409.05839.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <479E1D9E.3000900@bobjweil.com> <20080128185345.CF0A51871238@smtp03.mtu.ru>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Andrey Borzenkov wrote:
>Richard Heck wrote:
>> Daniel Barkalow wrote:
>>> Can you switch back to old IDE to get your work done (and to make sure
>>> it's not a hardware issue that's developed recently)?
>>
>> I think it'd be really, REALLY helpful to a lot of people if you, or
>> someone, could explain in moderate detail how this might be done. I
>> tried doing it myself, but I'm not sufficiently expert at configuring
>> kernels that I was ever able to figure out how to do it.
>
>well, here on Mandriva I
>
>1) compile both IDE and libata as modules
>2) create initrd that contains either IDE or libata modules
>3) use labels for file system mounts, swaps and resume device.
>
>
>Now 1) should be pretty straightforward (I could send you config if you
>like, it is stripped down to bare minimum on my system, you will have to
>check drivers for your hardware). 2 and 3 are obviously distribution
>dependent. I can explain how to do it on Mandriva that ATM has near to
>perfect support for addressing devices via label/UUID; also ide/scsi/ata
>switch is trivial using Mandriva mkinitrd.
>
>-andrey
>
>> Obviously, the short version is: switch back to Fedora 6. But this kind
>> of problem with libata---and yes, you're almost surely right that it's
>> not one problem but lots---is sufficiently widespread that a Mini HOWTO,
>> say, would be really welcome and, I'm guessing, widely used.
>>
>> Richard

I already build as modules, and it would be relatively easy to make 2 boot 
stanza's that used the different initrd's if there were examples that could 
be used as 'excludes' when building the initrd's.  Is such a creature 
breedable?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It's no wonder they call it WinNT; WNT = VMS++;

   -- Chris Abbey
%   
Peace, Love and Compile the kernel...

   -- Justin L. Herreman
