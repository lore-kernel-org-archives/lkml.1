Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYFWTiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYFWTiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYFWTiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:38:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbYFWTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:38:12 -0400
Date: Mon, 23 Jun 2008 21:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Bernhard Walle <bwalle@suse.de>, Greg KH <gregkh@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Johannes Weiner <hannes@saeurebad.de>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080623193650.GB20535@elte.hu>
References: <20080622185327.348377223@mini.kroah.org> <20080622190131.GB20141@suse.de> <87prq9dxst.fsf@skyscraper.fehenstaub.lan> <20080622203047.GC20800@suse.de> <alpine.LFD.1.10.0806221336010.2926@woody.linux-foundation.org> <20080623080940.GA23313@elte.hu> <20080623192012.GA15183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623192012.GA15183@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> > thanks. This patch (which was not a build fix but an infrastructure 
> > fix that the kexec fix in arch/x86 depended on) is well-tested as 
> > well, it was queued in -tip on June 10th:
> > 
> > | commit 91d48fc80f22817332170082e10de60a75851640
> > | Author: Bernhard Walle <bwalle@suse.de>
> > | Date:   Sun Jun 8 15:46:29 2008 +0200
> > | CommitDate: Tue Jun 10 14:41:56 2008 +0200
> > |
> > |    bootmem: add return value to reserve_bootmem_node()
> > |
> > |    This patch changes the function reserve_bootmem_node() from void to
> > |    int, returning -ENOMEM if the allocation fails.
> > |
> > |    Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > |    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > so it is a -stable candidate just as much as the kexec fix. (These 
> > are all fixes for long-standing problems so i guess it can go all 
> > the way back to all stable kernels that are being maintained.)
> 
> Hm, but it's not in Linus's tree yet, so I can't take it for stable at 
> this time :(

it's all fine already: it's the very same patch you just added, but 
different sha1. I just pointed out the lineage and the testing status of 
the patch.

	Ingo
