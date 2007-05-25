Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbXEYGPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbXEYGPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXEYGO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:14:59 -0400
Received: from brick.kernel.dk ([80.160.20.94]:15092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbXEYGO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:14:59 -0400
Date: Fri, 25 May 2007 08:12:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070525061200.GG7653@kernel.dk>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com> <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com> <20070523071103.GE4705@kernel.dk> <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com> <20070524072550.GC15375@kernel.dk> <Pine.LNX.4.64.0705240953270.28086@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705240953270.28086@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24 2007, Christoph Lameter wrote:
> On Thu, 24 May 2007, Jens Axboe wrote:
> 
> > On Wed, May 23 2007, Christoph Lameter wrote:
> > > On Wed, 23 May 2007, Jens Axboe wrote:
> > > 
> > > > That works for me with the patch, .config attached.
> > > 
> > > Hmmmm... That means the .config sent initially here was bogus.
> > 
> > ?
> > 
> > Considering we're trying to help you fix bugs in your code, you could be
> > considerably more helpful.
> 
> I am trying figure out what is wrong and somehow that is not helpful? The 
> data that we have right now about the bug does not give us a clear 

You are doing what you are supposed to do, fixing your broken code. We
are the ones that are helping you do that, by reporting the problem and
testing solutions. I think you have your attributions backwards.

> picture. One explanation that would have made it consistent would be that 
> the .config posted was not reflecting the actual kernel in use.

The .config I sent is the one that the last boot of the machine was
based on. The kernel is 2.6.22-rc2 with the patch moving the #ifdef from
you, and it works for me with or without CONFIG_SLUB_DEBUG set.

-- 
Jens Axboe

