Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZIJKBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZIJKBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZIJKBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:01:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53665 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZIJKBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:01:46 -0400
Date: Thu, 10 Sep 2009 12:01:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910100148.GF18599@kernel.dk>
References: <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <20090910094821.GC18599@kernel.dk> <20090910095933.GA21314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910095933.GA21314@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Sep 09 2009, Ingo Molnar wrote:
> > > At least in my tests these latencies were mainly due to a bug in 
> > > latt.c - i've attached the fixed version.
> > 
> > What bug? I don't see any functional change between the version 
> > you attach and the current one.
> 
> Here's the diff of what i fixed yesterday over the last latt.c 
> version i found in this thread. The poll() thing is the significant 
> one.

Ah indeed, thanks Ingo! I'm tempted to add some actual work processing
into latt as well, to see if that helps improve it.

-- 
Jens Axboe

