Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbXI1RWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbXI1RWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXI1RWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:22:30 -0400
Received: from mga06.intel.com ([134.134.136.21]:57452 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbXI1RW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="235058920"
Date: Fri, 28 Sep 2007 10:22:01 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070928172201.GB3219@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927232501.79f9f4bd.akpm@linux-foundation.org> <20070928064113.GA32532@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928064113.GA32532@linux-sh.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 03:41:13PM +0900, Paul Mundt wrote:
> On Thu, Sep 27, 2007 at 11:25:01PM -0700, Andrew Morton wrote:
> > On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> > > +int qos_add_requirement(int qos, char *name, s32 value);
> > > +int qos_update_requirement(int qos, char *name, s32 new_value);
> > > +void qos_remove_requirement(int qos, char *name);
> > 
> > It's a bit rude stealing the entire "qos" namespace like this - there are
> > many different forms of QoS, some already in-kernel.
> > 
> > s/qos/pm_qos/g ?
> 
> lat_qos or something might be more suitable.. it's a latency property, not
> a power management one (even if pm ends up being the primary user of it).

Its not just latency otherwise I'd agree with you.  right now I'm
thinking of changing things to "qospm" unless there folks feel strongly
about pm_qos.

--mgross
