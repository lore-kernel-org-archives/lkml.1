Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYLCT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYLCT2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYLCT2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:28:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57566 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYLCT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:28:14 -0500
Date: Wed, 3 Dec 2008 14:26:06 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [PATCH] add tracepoints to track change in napi
	states on network receive
Message-ID: <20081203192606.GC6549@hmsreliant.think-freely.org>
References: <20081202195129.GA30042@hmsreliant.think-freely.org> <20081202200150.GA27282@Krystal> <20081203160134.GA6549@hmsreliant.think-freely.org> <20081203172507.GA4471@Krystal> <20081203174500.GB6549@hmsreliant.think-freely.org> <20081203181105.GA6794@Krystal> <20081203182133.GB6794@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203182133.GB6794@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 01:21:33PM -0500, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > * Neil Horman (nhorman@tuxdriver.com) wrote:
> > > On Wed, Dec 03, 2008 at 12:25:07PM -0500, Mathieu Desnoyers wrote:
> > > > Almost there :)
> > > > 
> > > > There is a extra whitespace above,
> > > > 
> > > > and also  "schedule napi_struct" should probably be changed into
> > > > napi_struct only, this removes the whitespace and duplicated information
> > > > (I guess we know that given we are in event net_napi_schedule, this will
> > > > have something to do with schedule...). Same applies to trace_mark_tp
> > > > below.
> > > > 
> > > > Thanks,
> > > > 
> > > > Mathieu
> > > 
> > > 
> > > Sure, here you go, new patch
> > > 
> > > Patch to trace napi states for various net devices and their napi instances.
> > > Traces scheduling, servicing and completion of a napi poll request.
> > > 
> > > Regards
> > > Neil
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > 
> > Actually I notice that you used the old "DEFINE_TRACE" tracepoint API.
> 
> The patch has been edited and folded into 
> lttng-instrumentation-net.patch
> lttng-instrumentation-net-tracepoints-probes.patch
> 
Thanks!
Neil


-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
