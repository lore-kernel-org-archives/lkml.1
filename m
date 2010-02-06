Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0BFLqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 06:46:50 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45224 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0BFLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 06:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a5muKKDTGG3qhIen3Z3njCY5a4zOKVif3rVtkcxPppUR1P+KILEjj4hBCuLrwaIKOz
         6bL5B+nT1tsqqXxWDHn2Gja1SCKhbV9x0pfTgrvlvRO7i9RRO0ef8kssZZH4DD5YWkJQ
         DUMn/8YZ/uSD0YZlvXEazNjVflZkVCCOKKRYs=
Date: Sat, 6 Feb 2010 12:46:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20100206114634.GE5062@nowhere>
References: <20090925122556.2f8bd939@infradead.org> <20100205154748.GA11469@infradead.org> <20100205222430.1d17a72c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205222430.1d17a72c@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 10:24:30PM -0800, Arjan van de Ven wrote:
> On Fri, 5 Feb 2010 10:47:48 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Fri, Sep 25, 2009 at 12:25:56PM +0200, Arjan van de Ven wrote:
> > > >From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00
> > > >2001
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Fri, 25 Sep 2009 12:20:57 +0200
> > > Subject: [PATCH] perf_core: provide a kernel-internal interface to
> > > get to performance counters
> > 
> > So this patch got accepted into mainline a while ago, without a user
> > ever beeing presented, nevermind actually included in mainline.  Time
> > to revert providing these useless exports and dead code?
> > 
> 
> 
> Frederic had a user near mainline.
> 
> I have one but it's .35 material at this point...
> 
> if you want to insist to bounce the patch out now and back in
> for .35... I don't care but Frederic might.


We can't.
It has a user merged upstream: the hw-breakpoint subsystem.

