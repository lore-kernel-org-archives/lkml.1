Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXDULGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXDULGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXDULGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:06:17 -0400
Received: from amsfep19-int.chello.nl ([62.179.120.14]:59826 "EHLO
	amsfep19-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030721AbXDULGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:06:16 -0400
Subject: Re: [PATCH 07/10] mm: count reclaimable pages per BDI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-Reply-To: <20070421025521.8d77072e.akpm@linux-foundation.org>
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.222304356@chello.nl>
	 <20070421025521.8d77072e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 13:04:24 +0200
Message-Id: <1177153464.2934.39.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 02:55 -0700, Andrew Morton wrote:
> On Fri, 20 Apr 2007 17:52:01 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Count per BDI reclaimable pages; nr_reclaimable = nr_dirty + nr_unstable.
> 
> hm.  Aggregating dirty and unstable at inc/dec time is a bit kludgy.  If
> later on we want to know just "dirty" then we're in trouble.
> 
> I can see the logic behind it though.
> 
> Perhaps one could have separate BDI_DIRTY and BDI_UNSTABLE and treat them
> separately at inc/dec time, but give them the same numerical value, so
> they in fact refer to the same counter.  That's kludgy too.

:-(

I struggled with it too; don't have a ready solution either. I'll do
whatever the consensus agrees upon.

