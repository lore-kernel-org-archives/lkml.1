Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYHUC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYHUC0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYHUC0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:26:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:48867 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751004AbYHUC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="327899121"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <20080820134708.GA20648@elte.hu>
References: <1912217169.25608.228.camel@ymzhang>
	 <1218180605.8625.64.camel@twins>
	 <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
	 <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
	 <20080820105141.GA18226@elte.hu> <1219239137.8651.52.camel@twins>
	 <20080820134708.GA20648@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2008 10:25:02 +0800
Message-Id: <1219285502.8781.35.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-20 at 15:47 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Just realized my brainfart..
> > 
> > ---
> > Subject: sched: load-balance bias fixes
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Aug 20 15:28:51 CEST 2008
> > 
> > Yanmin spotted a regression with my patch that introduces LB_BIAS:
> 
> ok, i've applied this one to tip/sched/urgent instead of the 
> feature-disabling patchlet. Yanmin, could you please check whether this 
> one does the trick?
This new patch almost doesn't help volanoMark. Pls. use the patch
which sets ﻿LB_BIAS=1 by default.

-yanmin


