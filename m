Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYD3KGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYD3KGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYD3KFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:05:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754824AbYD3KFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:05:55 -0400
Date: Wed, 30 Apr 2008 10:57:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 layout v5
Message-ID: <20080430105719.6b39cda0@core>
In-Reply-To: <m18wywuooz.fsf@frodo.ebiederm.org>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
	<m1wsmg32qk.fsf@frodo.ebiederm.org>
	<86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
	<m1abjcz9ow.fsf@frodo.ebiederm.org>
	<86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
	<m11w4oxq9i.fsf@frodo.ebiederm.org>
	<alpine.LFD.1.10.0804300050070.6003@apollo.tec.linutronix.de>
	<m18wywuooz.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The best definition I have heard of SMM mode is: smack the stupid OS
> that isn't doing what it should be doing at runtime mode.

Its also used for all sorts of ugly horrible hacks - like some boards
with broken latches on timers where the firmware uses SMM to emulate the
hardware and spins until the low byte flips before loading the time into
the RTC.

Thankfully on the newest cpus SMM mode is a bit more elegantly designed,
the original is a weird not quite real mode with extra bugs while nowdays
its more of a virtual machine
