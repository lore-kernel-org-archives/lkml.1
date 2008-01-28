Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbYA1Tfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbYA1Tfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbYA1TfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:35:03 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:45238 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbYA1TfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:35:00 -0500
Date: Mon, 28 Jan 2008 14:31:11 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <200801282221.53303.arvidjaar@mail.ru>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Richard Heck <rgheck@bobjweil.com>, linux-kernel@vger.kernel.org
Message-id: <200801281431.11733.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281409.05839.gene.heskett@gmail.com>
 <200801282221.53303.arvidjaar@mail.ru>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Andrey Borzenkov wrote:
>On Monday 28 January 2008, Gene Heskett wrote:
>> On Monday 28 January 2008, Andrey Borzenkov wrote:
>> >Richard Heck wrote:
>> >> Daniel Barkalow wrote:
>> >>> Can you switch back to old IDE to get your work done (and to make sure
>> >>> it's not a hardware issue that's developed recently)?
>> >>
>> >> I think it'd be really, REALLY helpful to a lot of people if you, or
>> >> someone, could explain in moderate detail how this might be done. I
>> >> tried doing it myself, but I'm not sufficiently expert at configuring
>> >> kernels that I was ever able to figure out how to do it.
>> >
>> >well, here on Mandriva I
>> >
>> >1) compile both IDE and libata as modules
>> >2) create initrd that contains either IDE or libata modules
>> >3) use labels for file system mounts, swaps and resume device.
>> >
>> >
>> >Now 1) should be pretty straightforward (I could send you config if you
>> >like, it is stripped down to bare minimum on my system, you will have to
>> >check drivers for your hardware). 2 and 3 are obviously distribution
>> >dependent. I can explain how to do it on Mandriva that ATM has near to
>> >perfect support for addressing devices via label/UUID; also ide/scsi/ata
>> >switch is trivial using Mandriva mkinitrd.
>>
>> I already build as modules, and it would be relatively easy to make 2 boot
>> stanza's that used the different initrd's if there were examples that
>> could be used as 'excludes' when building the initrd's.  Is such a
>> creature breedable?
>
>I am not sure I understand a question (it is not my native language) but
> here I simply do
>
>mkinitrd --omit-ide-modules --preload pata_ali --preload sd_mod ...
>
>or
>
>mkinitrd --omit-scsi-modules --preload alim15x3 --preload ide-disk ...
>
This looks doable, thanks.  I was trying to be cute above when I'm rather 
frustrated by all this.  I might have to fiddle a bit but I got the idea.

OTOH, I and about 15,000 others according to google, would be everlastingly 
gratefull if it was just fixed. :)

Thanks

>If you ask how --omit part is implemented I happily send you mkinitrd
> script.



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If everybody minded their own business, the world would go around a deal 
faster.
		-- The Duchess, "Through the Looking Glass"
