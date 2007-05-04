Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXEEAdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXEEAdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161598AbXEEAdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:33:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:2992 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161186AbXEEAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="242190454"
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
In-Reply-To: <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
	 <Pine.LNX.4.64.0705031839480.16296@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 04 May 2007 16:41:23 -0700
Message-Id: <1178322083.23795.217.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 18:45 -0700, Christoph Lameter wrote:
> Hmmmm.. One potential issues are the complicated way the slab is 
> handled. Could you try this patch and see what impact it has?
> 
The patch boost the throughput of TCP_STREAM test by 5%, for both slab
and slub.  But slab is still 5% better in my tests.

> If it has any then remove the cachline alignment and see how that 
> influences things.

Removing the cacheline alignment didn't change the throughput.

Tim
