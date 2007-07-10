Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbXGJHy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbXGJHy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXGJHyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:54:20 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:36365 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbXGJHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L6AgmO0hCbSTkAxJbSUuT3HJNHzHSyk/Ni2VgkI1Can9Cq5QGiXtjui3JiS1o/vdDNFpAdHpN7iDBv7MxkORPW91G9zIsGunEk47/heC0i7dAAnr+ifkf2zzCBB9IA22j0zwikh/2u8LOp+PSzaWt6dQr+4JE/wZvp8yhM5tZ5A=
Message-ID: <ca35ce500707100054q5f8cbf88s195b8ba488da6c93@mail.gmail.com>
Date: Tue, 10 Jul 2007 09:54:16 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707091923.38577.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <33435.81.207.0.53.1183993390.squirrel@secure.samage.net>
	 <ca35ce500707091000h780c98bdleb3872849f451c2a@mail.gmail.com>
	 <200707091923.38577.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/9, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > One more thing - when the modem finally runs in isochronous mode, yet
> > I cannot get high transfer rates. I can't get nothing more than
> > 3Mbits/s. When I used kernel 2.4 with bulk mode I had only 2.5 Mbit/s.
> > So there is a little progress, but still not too much. Is it possible
> > that weak and old hardware (Celeron 633 on a VIA chipset motherboard)
> > is causing this ?
>
> Is it actually running in isochronous mode?  (It prints some messages
> about this).  You may need new firmware (I've attached some recent
> firmware that was made available by Thomson UK without any licence
> conditions).

Unfortunatelly this firmware does not work with my modem. I get this
thing in the debug log:
Jul 10 09:26:27 srv kernel: speedtch 1-2:1.0: speedtch_upload_firmware entered
Jul 10 09:26:27 srv kernel: speedtch 1-2:1.0:
speedtch_upload_firmware: BLOCK1 uploaded (935 bytes)
Jul 10 09:26:29 srv kernel: usb 1-2: speedtch timed out on ep5in len=0/512

And it hangs at this point for a couple of minutes, so I have to
manually remove the speedtch module. As far as I can see my modem is
revision 2.00 (kernel searches for firmware speedtch-1.bin.2.00).

I also tried a couple of other firmwares available on the net, and
also the one from Windows XP install (which works and achieves speeds
of up to 720kbyte/sec downlink). Some of the firmwares did not work
either, and some worked the same way - it means not more than 3mbit/s
(around 400kbyte/s) could be achieved.

-- 
Regards,
MK
