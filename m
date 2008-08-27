Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYH0K5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYH0K5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYH0K5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:57:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:38739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYH0K5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:57:33 -0400
Date: Wed, 27 Aug 2008 12:57:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
Message-ID: <20080827105731.GC5818@wotan.suse.de>
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de> <1219833668.6462.72.camel@twins> <20080827105615.GB5818@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827105615.GB5818@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:56:15PM +0200, Nick Piggin wrote:
> On Wed, Aug 27, 2008 at 12:41:08PM +0200, Peter Zijlstra wrote:
> > Does it make sense to make this _double_lock_balance() thing depend on
> > that too?
> 
> Hmm, you might have a good point there. Greg?
> 
> BTW. I wonder about other architectures that are of interest to -rt? Like
> mips or arm perhaps... Any plans to implement ticket locks on those, or
> do they not tend to be used in SMP configurations on -rt yte?

Oh, or maybe I guess again: -rt might be using Greg's generic ticket lock
implementation?
