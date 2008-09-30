Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYI3LpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYI3LpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYI3Lo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:44:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYI3Lo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:44:58 -0400
Date: Tue, 30 Sep 2008 13:44:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] x86: split out dumpstack code from traps_xx.c
Message-ID: <20080930114437.GF21367@elte.hu>
References: <1222773135-1073-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222773135-1073-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Patches are against the current master branch of the tip tree. The 
> defconfigs compile fine and I ran some simple configs within qemu.

applied to tip/x86/traps:

 # 9bb2b4f: x86_64: split out dumpstack code from traps_64.c
 # f616942: i386: split out dumpstack code from traps_32.c

there were some interactions with other branches:

 054efa5: Merge branch 'tracing/nmisafe' into x86/traps
 9ecb7cf: Merge branch 'kmemcheck' into x86/traps
 8955b63: Merge branch 'core/signal' into x86/traps
 ff1b7a8: Merge branch 'x86/signal' into x86/traps
 76b22d8: Merge commit 'v2.6.27-rc8' into x86/traps
 b58c936: Merge branch 'x86/core' into x86/traps

I hope i sorted them out right.

	Ingo
