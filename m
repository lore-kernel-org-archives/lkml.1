Return-Path: <linux-kernel-owner+w=401wt.eu-S1161490AbXEDSbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490AbXEDSbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbXEDSbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:31:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:17847 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161490AbXEDSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:31:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,493,1170662400"; 
   d="scan'208";a="224394488"
Subject: RE: Regression with SLUB on Netperf and Volanomark
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Christoph Lameter <clameter@sgi.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0705041107290.23684@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
	 <Pine.LNX.4.64.0705031937560.16542@schroedinger.engr.sgi.com>
	 <1178298897.23795.195.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705041107290.23684@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 04 May 2007 10:39:11 -0700
Message-Id: <1178300352.23795.202.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 11:10 -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Tim Chen wrote:
> 
> > A side note is that for my tests, I bound the netserver and client to
> > separate cpu core on different sockets in my tests, to make sure that
> > the server and client do not share the same cache.  
> 
> Ahhh... You have some scripts that you run. Care to share?

I do

taskset -c 1 netserver

and

taskset -c 2 netperf  -t TCP_STREAM -l 60 -H 127.0.0.1 -- -s 57344 -S
57344 -m 4096

> 
> This is no NUMA syste? Two processors in an SMP system?

Yes, it is a SMP system with 2 socket.  Each socket has 4 cores.

Tim
