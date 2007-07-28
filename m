Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbXG1Lxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbXG1Lxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXG1Lxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:53:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44243 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755460AbXG1Lx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:53:28 -0400
Date: Sat, 28 Jul 2007 13:00:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Paul Fulghum <paulkf@microgate.com>, Tilman Schmidt <tilman@imap.cc>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070728130009.43ea9e14@the-village.bc.nu>
In-Reply-To: <46AACB4D.7080004@howardsilvan.com>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	<46A84B4A.6070902@shaw.ca>
	<46A8C6F1.4080309@howardsilvan.com>
	<20070726173121.70088a92@the-village.bc.nu>
	<46A98845.8010806@howardsilvan.com>
	<46A9F712.70706@imap.cc>
	<46D33636.7070200@microgate.com>
	<46AA5A0E.1050600@howardsilvan.com>
	<1185578908.2989.15.camel@x2>
	<46AACB4D.7080004@howardsilvan.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Curiously, the session at 38400 bps that skipped 858 bytes... coincided, 
> not just in sequence but also in precice timing within the session, with 
> a small but noticeable disk load that I caused by grepping through a 
> hundred session logs.  (I can't reproduce it easily, though, because of 
> disk caching.)

Can you send me a dmesg, there are some cases when high disk load can
cause high interrupt latency in both 2.2 and 2.6 depending upon what is
configured. I don't think thats related to the main problem but it is
worth knowing about hdparm -u1

> as it leaves the DCE.  I mention this in case there is any limitation to 
> how the 8250 driver performs when two modems are being run simultaneously.

It means more load but that shouldn't matter much, and the transmit side
if under load with asynchronous traffic will not lose bytes sending.

Alan
