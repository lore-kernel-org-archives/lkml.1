Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYIVI14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYIVI14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIVI1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:27:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYIVI1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:27:48 -0400
Date: Mon, 22 Sep 2008 10:27:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, davej@redhat.com
Subject: Re: [PATCH] raid: make RAID autodetect default a KConfig option
Message-ID: <20080922082728.GB6601@elte.hu>
References: <20080921154541.371f2ebe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921154541.371f2ebe@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From 812bf9a448d96375a3aec5c51764d74cace85abb Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 21 Sep 2008 15:44:32 -0700
> Subject: [PATCH] raid: make RAID autodetect default a KConfig option
> 
> RAID autodetect has the side effect of requiring synchronisation of 
> all device drivers, which can make the boot several seconds longer 
> (I've measured 7 on one of my laptops).... even for systems that don't 
> have RAID setup for the root filesystem (the only FS where this 
> matters).
> 
> This patch makes the default for autodetect a config option; either 
> way the user can always override via the kernel command line.

Neil, if you agree with this patch, could you please send your Acked-by 
line? This patch depends on a clean-up in init/do_mounts_md.c that is in 
the fastboot tree so it would be logistically easier/better if we could 
queue this up towards upstream via tip/fastboot.

	Ingo
