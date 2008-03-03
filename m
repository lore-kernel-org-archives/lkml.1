Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYCCRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYCCRqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYCCRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:46:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYCCRqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:46:19 -0500
Date: Mon, 3 Mar 2008 18:45:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes
	causing boot failure
Message-ID: <20080303174555.GA25496@elte.hu>
References: <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie> <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com> <20080228154244.GA4038@csn.ul.ie> <86802c440802280945w4dd71038y95936656cd535c9c@mail.gmail.com> <20080303162711.GD5861@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303162711.GD5861@csn.ul.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> > can you verify which one fix that ?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
> 
> This one was the fix.
> 
> commit a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Tue Feb 19 15:35:54 2008 -0800
> 
>     x86_64: not set node to cpu_to_node if the node is not online

thanks - so should we accelerate this into v2.6.25?

	Ingo
