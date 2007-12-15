Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbXLOBME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbXLOBME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXLOBLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:11:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:61276 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXLOBLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:11:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,170,1196668800"; 
   d="scan'208";a="439919360"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: ARP Bug?
Date: Fri, 14 Dec 2007 17:11:52 -0800
Message-ID: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ARP Bug?
Thread-Index: Acg+t3oLTt8aGwoWSum4AjmxOhPOKQ==
From: "Gosney, JeremiX" <jeremix.gosney@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Peters, Gordon" <gordon.peters@intel.com>,
       "Sy, Dely L" <dely.l.sy@intel.com>
X-OriginalArrivalTime: 15 Dec 2007 01:11:53.0267 (UTC) FILETIME=[7A595030:01C83EB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've noticed the 2.6-based Linux systems in our test lab are
experiencing some "ARP flux"-like symptoms.  

The systems reply with eth0's hardware address to all ARP requests,
regardless of the IP being queried.  Because of this, the system will
only send and receive packets on eth0; if eth0 is brought down, the
system is unreachable even though it still has several active
connections.  With eth0 unplugged, none of the other interfaces are
reachable (this is presumably a side-effect caused by the switch ARP
cache.) Failover routes are defined in the routing table, but the system
still will not send/receive packets out those interfaces.

Can anything be done to correct this behaviour?


Jeremi M Gosney
Enterprise Linux Engineer
DIJIC, Intel Corporation
Work: 253-371-4849
Mobile: 253-495-4254

