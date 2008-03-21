Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYCUSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYCUSpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYCUSpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:45:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45811 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbYCUSpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:45:43 -0400
Date: Fri, 21 Mar 2008 19:45:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080321184526.GB6571@elte.hu>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com> <20080319214227.GA4454@elte.hu> <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com> <20080321110008.GW20420@elte.hu> <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 21 Mar 2008, Ingo Molnar wrote:
> 
> > then make STACKTRACE available generally via the patch below.
> 
> How do I figure out which nesting level to display if we'd do this?

the best i found for lockdep was to include a fair number of them, and 
to skip the top 3. struct vm_area that vmalloc uses isnt space-critical, 
so 4-8 entries with a 3 skip would be quite ok. (but can be more than 
that as well)

	Ingo
