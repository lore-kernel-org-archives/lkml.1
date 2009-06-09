Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZFINtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZFINtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbZFINtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:49:10 -0400
Received: from mga05.intel.com ([192.55.52.89]:29795 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761398AbZFINtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="464763113"
Date: Tue, 9 Jun 2009 21:32:32 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Fix incorrect default branch
Message-ID: <20090609133232.GA14642@ywang-moblin2.bj.intel.com>
References: <20090609074621.GA19290@ywang-moblin2.bj.intel.com> <20090609132313.GE25586@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609132313.GE25586@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 03:23:13PM +0200, Ingo Molnar wrote:
> 
> * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > The event selector and UMASK values of Nehalem do not apply to all 
> > Intel processors.
> 
> The idea was to offer _some_ sort of table on new CPUs, instead of 
> nothing...
> 
> Eventually Intel stops changing those model specific index values in 
> future CPUs and puts them into architectural perfmon, for 
> fundamental stats like L1/LLC cache statistics.
> 
> In that case defaulting to the latest (known) enumeration might work 
> out to be just the thing used by all future CPUs.
> 
> So this is a subtle hint ;-)
> 

I see what you mean. You talked about future cpus. But what about those
old ones that are not atom, core2 or nehalem? Forget about them?

Thanks
-Yong
