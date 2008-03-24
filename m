Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYCXTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYCXTsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYCXTsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:48:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYCXTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:47:59 -0400
Date: Mon, 24 Mar 2008 20:47:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080324194706.GA1391@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E59B39.90306@s5r6.in-berlin.de> <20080323063524.GA13018@elte.hu> <47E80247.8090702@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E80247.8090702@m3y3r.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Meyer <thomas@m3y3r.de> wrote:

>> send us the cfs-debug-info file that gets generated. We'll be able to 
>> tell from that whether your ioremap's are OK. (x86/latest will also 
>> printk all ioremap()s and results that are done)
>
> See attached file.

could you send the full bootlog too? (the dmesg in the cfs-debug-info 
log is truncated - probably CONFIG_LOG_BUF_SHIFT is too low?)

the bootlog should have such entries:

  ioremap: 0x12340000(0x00001000) => 0x12340000

near the ohci1394 initialization messages.

	Ingo
