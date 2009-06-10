Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZFJFxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZFJFxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZFJFw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:52:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:20683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZFJFw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,338,1241420400"; 
   d="scan'208";a="420390489"
Date: Wed, 10 Jun 2009 13:36:23 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Correct some event and umask
	values for Intel processors
Message-ID: <20090610053623.GC30923@ywang-moblin2.bj.intel.com>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com> <20090609141621.GA32703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609141621.GA32703@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 04:16:21PM +0200, Ingo Molnar wrote:
> 
> * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > Correct some event and UMASK values according to Intel SDM.
> 
> Very nice, thanks!
> 
> were you able to test the Atom ones by any chance?
> 

You bet I was as I'm working on Moblin;-) However, some work while some
do not. I'll take a look at the problematic ones. With the previous
event and umask values, the pmc does not count at all for some events,
like l1d-write-ops.

Btw, one thing I don't quite understand is why you aliased
dtlb-write-ops to l1d-write-ops when setting event and umask values. Are
they the same event?

Thanks
-Yong
