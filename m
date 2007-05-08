Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXEHWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXEHWCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXEHWCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:02:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbXEHWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:02:52 -0400
Date: Tue, 8 May 2007 15:02:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: RE: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <1178658124.15701.35.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705081502130.15135@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
  <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com> 
 <1178322083.23795.217.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705041800070.28492@schroedinger.engr.sgi.com> 
 <1178584834.15701.18.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705071848300.1378@schroedinger.engr.sgi.com>
 <1178658124.15701.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Tim Chen wrote:

> I tried the slub-patches and the avoid atomic overhead patch against
> 2.6.21-mm1.  It brings the TCP_STREAM performance for SLUB to the SLAB
> level.  The patches not mentioned in the "series" file did not apply
> cleanly to 2.6.21-mm1 and I skipped most of those.  

Ahhh. Great. The patches not mentioned should not be applied corredct.

> Without skip atomic overhead patch, the throughput drops by 1 to 1.5%.
> 
> The change from slub_min_order=0 slub_max_order=4 
> to slub_min_order=6 slub_max_order=7 did not make much difference in
> my tests.

Allright. I will then put that patch in.

