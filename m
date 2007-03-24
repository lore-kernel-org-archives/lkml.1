Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXCXRau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXCXRau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 13:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbXCXRau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 13:30:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXCXRat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 13:30:49 -0400
Date: Sat, 24 Mar 2007 18:29:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070324172959.GB542@elte.hu>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de> <17925.18904.820106.145029@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17925.18904.820106.145029@gargle.gargle.HOWL>
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


* Nikita Danilov <nikita@clusterfs.com> wrote:

> Indeed, this technique is very well known. E.g., 
> http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole 
> section (3. Local-spin Algorithms) on them, citing papers from the 
> 1990 onward.

that is a cool reference! So i'd suggest to do (redo?) the patch based 
on those concepts and that terminology and not use 'queued spinlocks' 
that are commonly associated with MS's stuff. And as a result the 
contended case would be optimized some more via local-spin algorithms. 
(which is not a key thing for us, but which would be nice to have 
nevertheless)

	Ingo
