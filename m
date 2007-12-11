Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXLKVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXLKVPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXLKVPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:15:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44070 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbXLKVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:15:18 -0500
Date: Tue, 11 Dec 2007 22:15:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify mmap_{32|64}.c
Message-ID: <20071211211505.GC6902@elte.hu>
References: <1196889830.10408.50.camel@brick> <20071209081324.GB4509@elte.hu> <1197301855.1799.1.camel@brick> <20071211083917.GB20172@elte.hu> <20071211104321.GA21513@elte.hu> <Pine.LNX.4.64.0712111305000.12449@jikos.suse.cz> <20071211140830.GC12204@elte.hu> <1197400782.8761.10.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197400782.8761.10.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Ingo,
> 
> Brown paper bag for me.
> 
> in mmap.c in mmap_is_ia32()
> 
> #ifdef X86_32
> 
> should of course be:
> 
> #ifdef CONFIG_X86_32
> 
> This would definitely explain the segfaults.  Do you want a 
> replacement patch or incremental?

no need, i'll fix it up.

	Ingo
