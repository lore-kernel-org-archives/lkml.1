Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYCCS46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYCCS46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYCCS4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:56:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53421 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYCCS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:56:48 -0500
Date: Mon, 3 Mar 2008 18:56:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Message-ID: <20080303185645.GA17414@csn.ul.ie>
References: <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie> <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com> <20080228154244.GA4038@csn.ul.ie> <86802c440802280945w4dd71038y95936656cd535c9c@mail.gmail.com> <20080303162711.GD5861@csn.ul.ie> <20080303174555.GA25496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080303174555.GA25496@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/03/08 18:45), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > > can you verify which one fix that ?
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
> > 
> > This one was the fix.
> > 
> > commit a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
> > Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> > Date:   Tue Feb 19 15:35:54 2008 -0800
> > 
> >     x86_64: not set node to cpu_to_node if the node is not online
> 
> thanks - so should we accelerate this into v2.6.25?
> 

I believe it needs to be merged for v2.6.25. According to test.kernel.org,
bl6-13 is failing boot tests in mainline so it's either this or a lot of
reverting.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
