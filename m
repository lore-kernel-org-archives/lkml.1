Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYEHIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYEHIMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYEHILq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:11:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbYEHILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:11:44 -0400
Subject: Re: [PATCH] sched: fix SCHED_OTHER balance iterator to include all
	tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       David Bahi <dbahi@novell.com>
In-Reply-To: <20080506120616.GI32591@elte.hu>
References: <20080505142739.24888.31658.stgit@lsg>
	 <20080506120616.GI32591@elte.hu>
Content-Type: text/plain
Date: Thu, 08 May 2008 10:11:25 +0200
Message-Id: <1210234285.13978.172.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 14:06 +0200, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > Hi Ingo,
> >  The follow patch applies to sched-devel.  I know the original 
> >  function was somehow trying to protect against dequeueing by 
> >  pre-iterating.  I am not sure if I captured the intent properly in 
> >  that regard.  What I can say is that the old algorithm would miss 
> >  tasks, and that is now fixed.  It may need further adjustment if I 
> >  missed the pre-iterating operation.
> > 
> > Hi Peter,
> >  I was wrong earlier when I mentioned there might be a problem with 
> >  entity_is_task().  I think this was the root cause of what I was 
> >  seeing. Sorry for the red-herring.
> 
> applied Gregory, thanks. Nice fix! Peter, do you concur with Gregory's 
> analysis?

Yeah,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

