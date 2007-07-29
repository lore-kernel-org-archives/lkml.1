Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbXG2Sqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbXG2Sqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXG2Sqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:46:32 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:22651 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759887AbXG2Sqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:46:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 14:46:31 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VssE8rksVsl9fiNRv1cya9LemLVkfGnVe5kzkuNzl5JAFsKi4qxbEkzPbaCnbIO1V/877XdDkIkpC4OsNXaFTUs4taD4AVMRjvFEAp7x5/JxU9Df+xCMZ2SSDfsuMWA7CWPCJzM/WxAvpkQSvhk/cu4cZJArBSzZsL36lhcsrio=;
X-YMail-OSG: jzN3KbAVM1kmwlBZVwL8W4CAEwdfNNMGc5JuupN9UFxZfmA1yoxVZWd11dgD2_gMxgMhtVnpQAgoEbzj1mJZm4_H1Rb6cOgR14Ovijv79hrc6b2xe4p0pVy5f7oHmZb9BnYdv.foqshejD0-
Date: Sun, 29 Jul 2007 11:39:50 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Re: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
In-Reply-To: <46ACB357.4030006@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <415666.7221.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Probably a similar problem is described in the
linux-ide mailing list a while ago:

http://www.opensubscriber.com/message/jgarzik@pobox.com/6490911.html

>> Argh. I'm seeing a show stopper bug on sata_nv
here. 
>> ata_exec_internal  
>> is MCE-ing on the READ_NATIVE_MAX_EXT command on 
>> both i386 and amd64, with  
>> top of Linus' tree + this patch. :(  
>
>Oddly, the command at least executes and doesn't MCE
>(but it's not at all  
>happy either) if I use ATA_PROT_PIO. I wonder if
>ATA_PROT_NODATA is buggered on this sata_nv chip
>(Asus A8N-E).  

At least it is a similar motherboard that is used
(however I have explicitly have the A8N-E Deluxe
edition).

I try not to repair my SATA disk for now with the
Seatools, so if there is some testing to be done, I
can run it with the bad disk.

Regards,
Hendrik


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC
