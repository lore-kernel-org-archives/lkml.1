Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXGIRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXGIRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXGIRlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:41:40 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:3578 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXGIRlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kOD81MUCrhtFx35JeqsUPPH+mnqcn8NVOt2N1N8Tcwgd+VVgUgAY0Q6JZ1UZv6VGcZdLwHbGZOK3AVisDhNQHyFRKtdv0EcIq6ECG0ZgmD7jC0balaItrEu9JRWP4vsgO0QBADPvNLa6r8PNX57dVWFzzhIZyMa1xVnIG/23f8U=
Message-ID: <ca35ce500707091041r1e660ca8h317e4936089d59aa@mail.gmail.com>
Date: Mon, 9 Jul 2007 19:41:38 +0200
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
> about this).

This is what I get:
root@srv:/# cat /sys/module/speedtch/parameters/enable_isoc
Y

I think it means it confirms the isochronous mode is working.
Especially that I modified the source of the speedtch.c so that the
enable_isoc is on by default.


> You may need new firmware (I've attached some recent
> firmware that was made available by Thomson UK without any licence
> conditions).

Many thanks for your great support. I will try the new firmware
tomorrow, as this is a remote machine and I would now risk loosing it
for an entire evening and night in case something goes wrong (usually
it just does go wrong :)

-- 
Regards,
MK
