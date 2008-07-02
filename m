Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbYGBCsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbYGBCsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYGBCsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:48:08 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:43841 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbYGBCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:48:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADSGakh5LBzp/2dsb2JhbACyQA
X-IronPort-AV: E=Sophos;i="4.27,735,1204464600"; 
   d="scan'208";a="139997819"
Date: Wed, 2 Jul 2008 12:47:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dean Nelson <dcn@sgi.com>, Robin Holt <holt@sgi.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Delayed interrupt work, thread pools
Message-ID: <20080702024719.GV29319@disturbed>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dean Nelson <dcn@sgi.com>, Robin Holt <holt@sgi.com>,
	ksummit-2008-discuss@lists.linux-foundation.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1214916335.20711.141.camel@pasglop> <20080701130240.GD10511@sgi.com> <20080702013927.GA2264@sgi.com> <1214966332.21182.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214966332.21182.2.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 12:38:52PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2008-07-01 at 20:39 -0500, Dean Nelson wrote:
> > As Robin, mentioned XPC manages a pool of kthreads that can (for performance
> > reasons) be quickly awakened by an interrupt handler and that are able to
> > block for indefinite periods of time.
> > 
> > In drivers/misc/sgi-xp/xpc_main.c you'll find a rather simplistic attempt
> > at maintaining this pool of kthreads. 
.....
> > I'd love it if a general mechanism were provided so that XPC could get out
> > of maintaining its own pool.
> 
> Thanks. That makes one existing in-tree user and a one likely WIP user,
> probably enough to move forward :-)

FWIW, the NFS server has a fairly sophisicated thread pool
implementation that allows interesting control of pool
affinity. Look up struct svc_pool in your local tree ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
