Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbXLLBlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbXLLBlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXLLBlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:41:39 -0500
Received: from hosted02.westnet.com.au ([203.10.1.213]:45686 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXLLBli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:41:38 -0500
From: Mike Lampard <mike@secnet.net.au>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 12:10:40 +1030
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121210.43350.mike@secnet.net.au>
X-GROMMIT-SECNET-NET-AU-MailScanner: Found to be clean
X-GROMMIT-SECNET-NET-AU-MailScanner-SpamCheck: 
X-GROMMIT-SECNET-NET-AU-MailScanner-From: mike@secnet.net.au
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 10:01:18 am Rene Herman wrote:
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

cycles: out 1399, in 303
cycles: out 1347, in 297
cycles: out 1235, in 251
cycles: out 1342, in 249
cycles: out 1393, in 274
cycles: out 1241, in 261
cycles: out 1238, in 251
cycles: out 1383, in 277
cycles: out 1228, in 252
cycles: out 1413, in 303
cycles: out 1394, in 268
cycles: out 1378, in 292
cycles: out 1239, in 265

 -m32 build on x64
processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 1
cpu MHz         : 2300.000
