Return-Path: <linux-kernel-owner+w=401wt.eu-S2993206AbXEBOBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993206AbXEBOBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993214AbXEBOBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:01:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60978 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993206AbXEBOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:01:20 -0400
Date: Wed, 2 May 2007 09:01:15 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: "partical" kthread conversion
Message-ID: <20070502140115.GA23595@sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084245.GA14364@infradead.org> <20070501015141.f09f6dde.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501015141.f09f6dde.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 01:51:41AM -0700, Andrew Morton wrote:
> On Tue, 1 May 2007 09:42:45 +0100 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Apr 30, 2007 at 04:20:07PM -0700, Andrew Morton wrote:
> > >  macintosh-mediabay-convert-to-kthread-api.patch
> > >  macintosh-adb-convert-to-the-kthread-api.patch
> > >  macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
> > >  powerpc-pseries-rtasd-convert-to-kthread-api.patch
> > >  powerpc-pseries-eeh-convert-to-kthread-api.patch
> > > 
> > > Will send to paulus (I already did - does Paul not handle the macintosh
> > > driver?)
> > 
> > Please don't send out the partial kthread conversions, as they're not
> > that helpful.  Depending on the way we'll let the API evolve a
> > kthread_create/run not paired by a kthread_stop might be actually harmful.
> > 
> > Please only send along patches that are paired or always built in so that
> > they don't require stopping at all.
> > 
> > Btw, many of the drivers above should probably go to benh.
> > 
> > There's probably a few more patches falling into this category, these
> > were just the first one the stick into my eye.
> 
> Yes, I think I'll probably drop all of them - I've completely lost track of
> which ones are complete, which ones need more work, etc.
> 
> I might send ia64-sn-xpc-convert-to-use-kthread-api.patch+fixes off to
> Tony, as people put quite a bit of review and test effort into that one.

Andrew, I would recommend holding off on sending these xpc patches to
Tony as the kthread_run()s aren't paired with kthread_stop()s yet. I
need to generate an additional patch after I've first sorted out how
best to deal with kthread_stop()'ng XPC's pool of kthreads with Eric.

Thanks,
Dean
