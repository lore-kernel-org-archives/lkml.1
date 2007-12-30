Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbXL3VcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbXL3VcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXL3Vbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:31:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbXL3Vbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:31:53 -0500
Date: Sun, 30 Dec 2007 22:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on
	x86-64
Message-ID: <20071230213126.GB14654@elte.hu>
References: <200712281353.37976.rjw@sisk.pl> <200712302204.56977.rjw@sisk.pl> <20071230205104.GB26120@elte.hu> <200712302248.03567.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712302248.03567.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > how different can it be, for resume to work? I mean, we'll have 
> > deeply kernel version dependent variables in RAM. Am i missing 
> > something obvious?
> 
> On x86-64 it can be almost totally different (by restoring a 
> hibernation image we replace the entire contents of RAM with almost no 
> constraints).
> 
> [Well, using a relocatable kernel for restoring an image with 
> nonrelocatable one or vice versa is rather not the best idea, but 
> everything else should work in theory.]
> 
> On i386 the boot kernel is still required to be the same as the one in 
> the image.

what's exactly in the hibernation image? Dirty data i suppose - but what 
about kernel-internal pages. What if we go from SLAB to SLUB? What if 
the size of a structure changes? Etc.

	Ingo
