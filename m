Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXIJA5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXIJA5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 20:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXIJA50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 20:57:26 -0400
Received: from mga05.intel.com ([192.55.52.89]:28450 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131AbXIJA5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 20:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,228,1186383600"; 
   d="scan'208";a="300252887"
Subject: Re: tbench regression - Why process scheduler has impact on tbench
	and why small per-cpu slab (SLUB) cache creates the scenario?
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <200709081808.42421.nickpiggin@yahoo.com.au>
References: <1188953218.26438.34.camel@ymzhang>
	 <1188969725.26438.46.camel@ymzhang>
	 <Pine.LNX.4.64.0709050006330.7567@schroedinger.engr.sgi.com>
	 <200709081808.42421.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Mon, 10 Sep 2007 08:56:32 +0800
Message-Id: <1189385792.14611.1.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 18:08 +1000, Nick Piggin wrote:
> On Wednesday 05 September 2007 17:07, Christoph Lameter wrote:
> > On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> > > > slub_max_order=3 slub_min_objects=8
> > >
> > > I tried this approach. The testing result showed 2.6.23-rc4 is about
> > > 2.5% better than 2.6.22. It really resovles the issue.
> >
> > Note also that the configuration you tried is the way SLUB is configured
> > in Andrew's tree.
> 
> It still doesn't sound like it is competitive with SLAB at the same sizes.
> What's the problem?
Process scheduler and small SLUB per-cpu cache work together to create the tebnch regression.

Pls. see the starting of the thread.

-yanmin
