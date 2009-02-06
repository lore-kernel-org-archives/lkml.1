Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZBFEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZBFEwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 23:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZBFEwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 23:52:14 -0500
Received: from mga06.intel.com ([134.134.136.21]:49044 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388AbZBFEwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 23:52:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,389,1231142400"; 
   d="scan'208";a="384548609"
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ming.m.lin@intel.com
In-Reply-To: <20090205120608.GB8799@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 12:51:59 +0800
Message-Id: <1233895919.2604.323.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 13:06 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > This should hopefully address all the itimer borkage.
> 
> Applied to tip:timers/urgent, thanks Peter!
> 
> Yanmin: could you check hacbench_pth with latest tip/master, do
> these fixes resolve that 3% regression you reported?
Lin Ming tested it and hackbench_pth/volanoMark regression all
disappear. But oltp has a regression. We think oltp new regression isn't related
to the patch. Ming is investigating it.

Yanmin


