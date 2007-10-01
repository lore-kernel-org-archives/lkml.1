Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbXJAQMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbXJAQMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXJAQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:12:09 -0400
Received: from mga10.intel.com ([192.55.52.92]:44053 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752057AbXJAQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,216,1188802800"; 
   d="scan'208";a="159946982"
Date: Mon, 1 Oct 2007 09:11:41 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20071001161141.GA6584@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927232501.79f9f4bd.akpm@linux-foundation.org> <20070928171921.GA3219@linux.intel.com> <20070928115141.c5a7c9da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928115141.c5a7c9da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:51:41AM -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:19:21 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> 
> > On Thu, Sep 27, 2007 at 11:25:01PM -0700, Andrew Morton wrote:
> > > On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> > > 
> > > > +#define QOS_RESERVED 0
> > > > +#define QOS_CPU_DMA_LATENCY 1
> > > > +#define QOS_NETWORK_LATENCY 2
> > > > +#define QOS_NETWORK_THROUGHPUT 3
> > > > +
> > > > +#define QOS_NUM_CLASSES 4
> > > > +#define QOS_DEFAULT_VALUE -1
> > > > +
> > > > +int qos_add_requirement(int qos, char *name, s32 value);
> > > > +int qos_update_requirement(int qos, char *name, s32 new_value);
> > > > +void qos_remove_requirement(int qos, char *name);
> > > 
> > > It's a bit rude stealing the entire "qos" namespace like this - there are
> > > many different forms of QoS, some already in-kernel.
> > > 
> > > s/qos/pm_qos/g ?
> > 
> > I suppose it is a bit inconiderate.  I could grow to like pm_qos,
> > performance_throttling_constraint_hint_infrastructure is a bit too
> > wordy. 
> > 
> > I suppose I should use qospm as thats the way it was put up on that
> > lesswatts.org web page. 
> > 
> > Would qospm be good enough?
> > 
> 
> Don't think it matters a lot, but kernel naming tends to be big-endian (ie:
> we have net_ratelimit, not ratelimit_net), so the major part (pm) would
> come first under that scheme.

this makes sense.  pm_qos it is.

--mgross
