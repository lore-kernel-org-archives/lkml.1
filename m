Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXDRWQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXDRWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDRWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:16:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030285AbXDRWQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:16:28 -0400
Date: Thu, 19 Apr 2007 00:16:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070418221609.GA17347@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704182357.28107.mail@earthworm.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Hesse <mail@earthworm.de> wrote:

> Linux 2.6.21-rc7
> Suspend2 2.2.9.11 (applies cleanly to -rc7)
> CFS v3 (without any additional patches)
> 
> And it still hangs on suspend.

i just tried the same and it suspended+resumed just fine:

Restarting tasks ... done.
Suspend2 debugging info:
- Suspend core   : 2.2.9.12
- Kernel Version : 2.6.21-rc7-CFS-v3
- Compiler vers. : 4.0
- Attempt number : 2
- Parameters     : 0 81920 0 0 0 0
- Overall expected compression percentage: 0.
- Compressor is 'lzf'.
  Compressed 31133696 bytes into 14880587 (52 percent compression).
- SwapAllocator active.
  Swap available for image: 512036 pages.
- FileAllocator inactive.
- I/O speed: Write 76 MB/s, Read 42 MB/s.
- Extra pages    : 18 used/500.

could you send me your .config?

	Ingo
