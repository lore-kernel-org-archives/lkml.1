Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXKLRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXKLRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbXKLRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:38:08 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46152 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075AbXKLRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:38:07 -0500
Date: Mon, 12 Nov 2007 11:37:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86_64 SATA DVD drive + libata trouble
In-reply-to: <200711121748.53313.strieder@informatik.uni-kl.de>
To: Bernd Strieder <strieder@informatik.uni-kl.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Message-id: <47388F6F.9010603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <200711091933.01523.strieder@informatik.uni-kl.de>
 <20071109190413.0efe9318@the-village.bc.nu>
 <200711121748.53313.strieder@informatik.uni-kl.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Strieder wrote:
> I managed to get it running with the SuSE kernel when passing 
> adma=0 to sata_nv module, and I managed to get it running when 
> passing mem=2000M to the SuSE kernel. Thanks to Robert for those 
> hints.
> 
> The vanilla kernels I tried 2.6.23.1 and 2.6.24-rc1-git10 (with 
> patch to sata_nv.c from Robert Hancock see 
> https://bugzilla.redhat.com/show_bug.cgi?id=351451)  seem to be 
> very sensitive in this area. Whenever I got them to oops, I did 
> not have much time to get anything read on the screen. 
> 
> I managed under the patched 2.6.24-rc1-git10 to manually load 
> sata_nv and sr_mod, and then I got an OOps like
> 
> Unable to handle ... NULL pointer dref at 0000000000000000 RIP 
> ffffff880edf6a
> .....
> 		libata:ata_qc_prep + 0xe2/0x15b
> .....
> 		srmod:sr_probe

Which patch is this using, the original one from Nov. 2 or the updated 
one from Nov. 10? The original one has a bug.

> I have  attached 3 dmesg outputs with the openSuSE 10.3 kernel and 
> extracts of /var/log/messages, especially some Oopses. The oopses 
> from the vanilla kernels seem to be so bad that they do never end 
> up in a file. 
> 
> I will do some more tests as soon as possible. I have attached the 
> files as I created them, you will have to diff the single files, 
> anyway, to get the important information out, I cannot select for 
> you.


