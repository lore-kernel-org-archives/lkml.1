Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbXI0UPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbXI0UPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXI0UPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:15:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:22300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbXI0UPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="234378703"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Steve Wise'" <swise@opengridcomputing.com>,
       "Sean Hefty" <mshefty@ichips.intel.com>
Cc: <rdreier@cisco.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
References: <20070923203649.8324.64524.stgit@dell3.ogc.int> <46FBF8AF.9040700@ichips.intel.com> <46FC03B8.1030106@opengridcomputing.com>
Subject: RE: [ofa-general] [PATCH v3] iw_cxgb3: Support "iwarp-only" interfaces to avoid 4-tuple conflicts.
Date: Thu, 27 Sep 2007 13:14:59 -0700
Message-ID: <000001c80143$15019140$82c8180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <46FC03B8.1030106@opengridcomputing.com>
Thread-Index: AcgBPDzt7iwZ8h2/SKSSl98ygzOOjQABm+BQ
X-OriginalArrivalTime: 27 Sep 2007 20:15:00.0608 (UTC) FILETIME=[14F4C000:01C80143]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>It is ok to block while holding a mutex, yes?

It's okay, I just didn't try to trace through the code to see if it ever tries
to acquire the same mutex in the thread that needs to signal the event.

- Sean
