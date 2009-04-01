Return-Path: <linux-kernel-owner+w=401wt.eu-S1765077AbZDAQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765077AbZDAQR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZDAQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:17:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbZDAQRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:17:15 -0400
Date: Wed, 1 Apr 2009 18:16:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
Message-ID: <20090401161657.GA13802@elte.hu>
References: <20090330180215.951354436@suse.com> <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Once this is applied, I expect reiserfs to be in deep 
> > maintenance-only mode.
> 
> Heh, I hadn't expected even this.

Note, there are BKL-removal patches in the works by Frédéric 
Weisbecker, for the tip:kill-the-BKL topic branch.

Reiser3 is the heaviest (and most non-trivial) BKL user amongst all 
the filesystems, its BKL use is recursive and it frequently relies 
on the implicit dropping of the BKL at various blocking points both 
for correctness and for performance reasons.

There might be something worth posting+reviewing soon.

	Ingo
