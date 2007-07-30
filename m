Return-Path: <linux-kernel-owner+w=401wt.eu-S937793AbXG3QM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937793AbXG3QM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762697AbXG3QMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:12:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53920 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762560AbXG3QMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:12:48 -0400
Date: Mon, 30 Jul 2007 17:19:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Attila Nagy <bra@fsn.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
Message-ID: <20070730171953.5fe93979@the-village.bc.nu>
In-Reply-To: <46AE0420.4030900@fsn.hu>
References: <46AE0420.4030900@fsn.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> MCE:
> [153103.918654] HARDWARE ERROR
> [153103.918655] CPU 1: Machine Check Exception:                5 Bank 0: 
> b200004010000400
> [153104.066037] RIP !INEXACT! 10:<ffffffff802569e6> {mwait_idle+0x46/0x60}
> [153104.145699] TSC 1167e915e93ce
> [153104.183554] This is not a software problem!
> [153104.234724] Run through mcelog --ascii to decode and contact your 
> hardware vendor

If you it through mcelog as it suggests it wil decode the meaning of the
MCE data and that should give you some idea. Generally speaking MCE
errors are real hardware errors but can certainly be caused by external
factors (power supply glitches, heat etc)
