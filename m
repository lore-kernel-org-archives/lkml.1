Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZJSHId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZJSHId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZJSHIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:08:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZJSHIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:08:32 -0400
Date: Mon, 19 Oct 2009 09:08:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfs mount fail
Message-ID: <20091019070825.GA16493@elte.hu>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com> <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com> <20091019114339.4b67d947@infradead.org> <1255921080.839.2.camel@penberg-laptop> <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org> <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255935518.18914.0.camel@penberg-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Mon, 2009-10-19 at 08:54 +0200, Ingo Molnar wrote:
> > * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > > yes. something miss merged again...
> > > > 
> > > > need change some lines.
> > > 
> > > This doesn't match mainline either. To do so, the above kfree() has to 
> > > be at the end of the "Opt_xprt_rdma:" case...
> > 
> > it's from a test patch in tip:out-of-tree:
> > 
> >   d40bc6b: <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()
> > 
> > (attached below)
> > 
> > that fix is wrong apparently - is there a correct fix upstream perhaps?
> 
> AFAICT, yes. See commit d508afb437daee7cf07da085b635c44a4ebf9b38 ("NFS:
> Fix a double free in nfs_parse_mount_options()") from Trond.

sigh. That was written 3 days after your and Yinghai's patch was sent - 
there's no Reported-by credit, there was no Cc: back to the original 
thread - plus there was a memory leak was left in there as well. Trond?

	Ingo
