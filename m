Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbXLKXlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbXLKXlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXLKXlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:41:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:6707 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbXLKXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=T2VT/WmlR+41rZwerc5hjjG8PkwT034HaY6K0r2Co2L4pDLG3WvQv+/UJ14IUGuxRZ1dWlaeHAe8m9XZNlp1UnxzrdRjPWZdZeQHFbq9xuk+s0DF4b1UEkrdHSsHHiBmN2dri1GZYe3LQWIrl9NhvwYB/EFq3TBX8xH1WpAuVcg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 01:40:34 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120140.34697.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 01:31:18 Rene Herman wrote:
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
> 


Sure,

maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1767, in 1147
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1774, in 1148
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1769, in 1150
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1769, in 1150
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1777, in 1150
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1766, in 1149
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1768, in 1148
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1765, in 1147


Core 2 Duo system (ICH8/Intel DG965RY motherboard)
