Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391Ab0A0FgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0A0FgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 00:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889Ab0A0FgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 00:36:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57443 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0A0FgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 00:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qJTJXWy79BgjCod2DEnPwWvHbGJUDWVJDTc7rkgeWC3LKd6a4yp3M/188N7SVKX0qz
         fNP9AnNCBKdjubAQ0iz8uEhsaE3mcumSEuWr3ILv7aL82E+Y6tihdlWT32Nfgx7xX4ew
         cQ3PnXqKT+y5yq/99fC/kERuSB+KqkOOUMQJM=
MIME-Version: 1.0
In-Reply-To: <4B5FA38A.5040700@teksavvy.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <4B5F62C2.4000800@pobox.com>
	 <aacba7e1001261624m4358e4ebwcf8e2305b0c5fc16@mail.gmail.com>
	 <4B5FA38A.5040700@teksavvy.com>
Date: Wed, 27 Jan 2010 11:06:13 +0530
Message-ID: <aacba7e1001262136o3b1cfb97yed421bba02580bef@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Mark Lord <kernel@teksavvy.com>:
> Can you identify the specific Indilinx build number that your drive firmware
> is based upon?  If not, then at least post the identify data for us to
> examine:
>
>  hdparm --Istdout /dev/sd?


Thanks for taking the time on this.

I am unsure of the "specific IndiLinx firmware build number" though I've
noticed the release numbers are common for different manufacturers.
For example my disk came with the then-latest firmware "1819"
(with TRIM) which had write-perf issues then they recently released
"1916" which added TRIM and GC support (seems to work very well
I should say).

Linux logs "CRUCIAL_CT128M225" and "1916" in my dmesg, speaking
of which, here is my latest full dmesg: http://pastebin.ubuntu.com/363659/

And here is the output of hdparm --Istdout /dev/sd? :
http://pastebin.ubuntu.com/363660/

I am running the following on Kubuntu development version, uname -a is:
"Linux thunderbird 2.6.32-11-generic #16~vishalrao2 SMP Tue Jan 26
19:03:33 IST 2010 x86_64 GNU/Linux"

The " ~vishalrao2 " portion indicating it being the proposed patch -
in that good old "works for me" kind of way.
