Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbXLKOIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbXLKOIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXLKOIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:08:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbXLKOIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:08:45 -0500
Date: Tue, 11 Dec 2007 15:08:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify mmap_{32|64}.c
Message-ID: <20071211140830.GC12204@elte.hu>
References: <1196889830.10408.50.camel@brick> <20071209081324.GB4509@elte.hu> <1197301855.1799.1.camel@brick> <20071211083917.GB20172@elte.hu> <20071211104321.GA21513@elte.hu> <Pine.LNX.4.64.0712111305000.12449@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712111305000.12449@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> > hm, it fails to boot on Fedora 8:
> >  Freeing unused kernel memory: 296k freed
> >  Write protecting the kernel read-only data: 1500k
> >  mount[623]: segfault at 0000000b ip 4d681ab6 sp bf9a1b94 error 6
> >  modprobe[625]: segfault at 0000000b ip 4d681ab6 sp bffd9994 error 6
> >  consoletype[629]: segfault at 0000000b ip 4d681ab6 sp bfb6ad14 error 6
> >  awk[632]: segfault at 0000000b ip 4d681ab6 sp bffe68c4 error 6
> >  fstab-decode[633]: segfault at 0000000b ip 4d681ab6 sp bff1c8c4 error 6
> >  setsysfont[634]: segfault at 0000000b ip 4d681ab6 sp bfdd0f74 error 6
> >  hwclock[637]: segfault at 0000000b ip 4d681ab6 sp bf963304 error 6
> >  touch[642]: segfault at 0000000b ip 4d681ab6 sp bf98cb34 error 6
> >  modprobe[651]: segfault at 0000000b ip 4d681ab6 sp bfbc0564 error 6
> >  rhgb-client[654]: segfault at 0000000b ip 4d681ab6 sp bfe9c024 error 6
> 
> Ingo,
> 
> just for clarification -- this happens with Harvery's merged code 
> (haven't looked at it yet), but not with the original code, do I 
> understand it correctly?

yeah, correct - your original randomization code is fine.

	Ingo
