Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXEAIvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXEAIvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXEAIvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:51:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbXEAIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:51:47 -0400
Date: Tue, 1 May 2007 01:51:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: "partical" kthread conversion
Message-Id: <20070501015141.f09f6dde.akpm@linux-foundation.org>
In-Reply-To: <20070501084245.GA14364@infradead.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501084245.GA14364@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 09:42:45 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 30, 2007 at 04:20:07PM -0700, Andrew Morton wrote:
> >  macintosh-mediabay-convert-to-kthread-api.patch
> >  macintosh-adb-convert-to-the-kthread-api.patch
> >  macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
> >  powerpc-pseries-rtasd-convert-to-kthread-api.patch
> >  powerpc-pseries-eeh-convert-to-kthread-api.patch
> > 
> > Will send to paulus (I already did - does Paul not handle the macintosh
> > driver?)
> 
> Please don't send out the partial kthread conversions, as they're not
> that helpful.  Depending on the way we'll let the API evolve a
> kthread_create/run not paired by a kthread_stop might be actually harmful.
> 
> Please only send along patches that are paired or always built in so that
> they don't require stopping at all.
> 
> Btw, many of the drivers above should probably go to benh.
> 
> There's probably a few more patches falling into this category, these
> were just the first one the stick into my eye.

Yes, I think I'll probably drop all of them - I've completely lost track of
which ones are complete, which ones need more work, etc.

I might send ia64-sn-xpc-convert-to-use-kthread-api.patch+fixes off to
Tony, as people put quite a bit of review and test effort into that one.

