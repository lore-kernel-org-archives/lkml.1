Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXI1RTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXI1RTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXI1RTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:19:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:64708 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbXI1RTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="235057094"
Date: Fri, 28 Sep 2007 10:19:21 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070928171921.GA3219@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927232501.79f9f4bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927232501.79f9f4bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:25:01PM -0700, Andrew Morton wrote:
> On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> 
> > +#define QOS_RESERVED 0
> > +#define QOS_CPU_DMA_LATENCY 1
> > +#define QOS_NETWORK_LATENCY 2
> > +#define QOS_NETWORK_THROUGHPUT 3
> > +
> > +#define QOS_NUM_CLASSES 4
> > +#define QOS_DEFAULT_VALUE -1
> > +
> > +int qos_add_requirement(int qos, char *name, s32 value);
> > +int qos_update_requirement(int qos, char *name, s32 new_value);
> > +void qos_remove_requirement(int qos, char *name);
> 
> It's a bit rude stealing the entire "qos" namespace like this - there are
> many different forms of QoS, some already in-kernel.
> 
> s/qos/pm_qos/g ?

I suppose it is a bit inconiderate.  I could grow to like pm_qos,
performance_throttling_constraint_hint_infrastructure is a bit too
wordy. 

I suppose I should use qospm as thats the way it was put up on that
lesswatts.org web page. 

Would qospm be good enough?

--mgross
