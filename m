Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZE2Fxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZE2Fxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 01:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZE2Fxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 01:53:30 -0400
Received: from mga06.intel.com ([134.134.136.21]:52449 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbZE2Fxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 01:53:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,268,1241420400"; 
   d="scan'208";a="416710315"
Date: Fri, 29 May 2009 13:37:02 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Remove masking and unmasking of
	LVT error register.
Message-ID: <20090529053701.GB13657@ywang-moblin2.bj.intel.com>
References: <20090528071655.GA21039@ywang-moblin2.bj.intel.com> <20090528083340.GA7530@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528083340.GA7530@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:33:40AM +0200, Ingo Molnar wrote:
> i'd suggest to remove the 'nmi' parameter as well to this function. 

Thanks for the comment. Just resubmitted a new patch removing the 'nmi'
parameter.

> (and any other dynamic flags that deal with nmi/irq distinctions)

Just wanna make sure before moving on. You want to remove things like
the 'nmi' field in perf_counter_hw_event and hw_perf_counter structs and
the 'nmi' parameter of perf_counter_overflow and perf_swcounter_event
functions, etc. Right?

Thanks
-Yong
