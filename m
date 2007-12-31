Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXLaMjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXLaMjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXLaMjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:39:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60634 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbXLaMjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:39:45 -0500
Date: Mon, 31 Dec 2007 12:29:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231122949.58edd1d2@the-village.bc.nu>
In-Reply-To: <20071231132054.GB26339@ucw.cz>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<4777BDA5.4050203@keyaccess.nl>
	<alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
	<20071231132054.GB26339@ucw.cz>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "You plug in PCI DEBUG card and it overclocks your machine" is bad
> scenario.. (I don't know if it does... can PCI card emulate ISA timings?)

Easily. Its a bit more restricted by later spec revisions but it can halt
your box of a week or two if it wants. Video cards used to pull this
stunt for marketing benchmark numbers.
