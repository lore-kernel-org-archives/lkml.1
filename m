Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbXLKXob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbXLKXob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXLKXoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:44:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:23213 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbXLKXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=tUZ4811Bl+SxIhH4ONoz5v7vf3cn0ytAMJeXuzrLjGA2446ZHtXNkCRubnQWXSMuWnDPT/FrqSPJ5G6B+CoL0SyF4kJgaFlWFMAWcuvakZPkfKWvVomp+2vrKF6LDWZQrSywHi+Hube2g/A9iC955/ZUTvKip98TyDV8MFyAd8g=
Date: Wed, 12 Dec 2007 00:43:16 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212004316.079e3a05@Varda>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 12 Dec 2007 00:31:18 +0100
Rene Herman <rene.herman@gmail.com> escribió:

> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> the attached program? This is about testing how long I/O port access to port 
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.
> 
> Posted a previous incarnation of this before, buried in the outb 0x80 thread 
> which had a serialising problem. This one should as far as I can see measure 
> the right thing though. Please yell if you disagree...
> 
> For me, on a Duron 1300 (AMD756 chipset) I have a constant:
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> 
> and on a PII 400 (Intel 440BX chipset) a constant:
> 
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
> 
> Results are (mostly) independent of compiler optimisation, but testing with 
> an -O2 compile should be most useful. Thanks!
> 
> Rene.

 On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:

 cycles: out 1844674407370808, in 1844674407369087
 
It is not constant but variations are not significant afaics

