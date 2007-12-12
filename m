Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXLLQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXLLQyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXLLQyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:54:05 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:51737 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbXLLQyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:54:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 17:53:50 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2664
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200712121753.54357.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 00:31:18 Rene Herman wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run
> the attached program? This is about testing how long I/O port access to
> port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in
> reporting.
>
> Posted a previous incarnation of this before, buried in the outb 0x80
> thread which had a serialising problem. This one should as far as I can see
> measure the right thing though. Please yell if you disagree...
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

Cyrix MII PR300 (225MHz), i430TX:    cycles: out 263, in 93
Pentium MMX 166MHz @133MHz, VIA VPX: cycles: out 163, in 163
Celeron 433MHz, i440BX:              cycles: out 620, in 305
Celeron 1.3GHz, i440BX:              cycles: out 2114, in 849
Celeron 1.7GHz (P4-based), i845:     cycles: out 2178, in 1651
Pentium 4 3.2GHz, i925X:             cycles: out 2824, in 1899
Xeon E5310 1.6GHz, Dell PE1950       cycles: out 2631, in 1606
Xeon 3050 2.13GHz, Dell PE860        cycles: out 3367, in 1959

-- 
Ondrej Zary
