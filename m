Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXETNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXETNqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXETNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:46:09 -0400
Received: from www.osadl.org ([213.239.205.134]:57592 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755619AbXETNqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:46:08 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070520101800.GC9892@osiris.ibm.com>
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos>
	 <200705191525.28400.kernel@prachanda.hub>
	 <1179601868.12981.127.camel@chaos>  <20070520101800.GC9892@osiris.ibm.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 15:52:21 +0200
Message-Id: <1179669141.21827.22.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 12:18 +0200, Heiko Carstens wrote:
> > I work out a more complex debug patch and pester you to test once I'm
> > done.
> 
> I've also tons of 'NOHZ: local_softirq_pending 08' that disappear with
> nohz=off. But I'm still running 2.6.21. Are there any patches that should
> fix this?
> Machine is a Lenovo T60p:
> 
> i686 Intel(R) Core(TM)2 CPU T7600  @ 2.33GHz GenuineIntel GNU/Linux

Hmm, that's a different problem than the 0x22 which shows up on
hyperthreading enabled P4 systems. Are you using plip ?

> Besides that I get a lot of clock skews on 'make headers_check', but
> these are unrelated to nohz:
> 
>   CHECK   include/asm/dasd.h
> make[2]: warning:  Clock skew detected.  Your build may be incomplete.
> make[2]: Warning: File `/dev/null' has modification time 5.1e+03 s in the future

Strange.

	tglx


