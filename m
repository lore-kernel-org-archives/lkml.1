Return-Path: <linux-kernel-owner+w=401wt.eu-S968117AbXILSNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968117AbXILSNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967252AbXILSNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:34613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967241AbXILSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,245,1186383600"; 
   d="scan'208";a="293528191"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Steve Wise'" <swise@opengridcomputing.com>, <rdreier@cisco.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <general@lists.openfabrics.org>
References: <20070912100025.3190.89259.stgit@dell3.ogc.int>
Subject: RE: [PATCH] RDMA/CMA: Use neigh_event_send() to initiate neighbour discovery.
Date: Wed, 12 Sep 2007 11:13:08 -0700
Message-ID: <000101c7f568$9275b520$ff0da8c0@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070912100025.3190.89259.stgit@dell3.ogc.int>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acf1I8UtmDxzc3iISJSaEODNOOvuwQARGFrA
X-OriginalArrivalTime: 12 Sep 2007 18:13:08.0444 (UTC) FILETIME=[925ED1C0:01C7F568]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>RDMA/CMA: Use neigh_event_send() to initiate neighbour discovery.
>
>Calling arp_send() to initiate neighbour discovery (ND) doesn't do the
>full ND protocol.  Namely, it doesn't handle retransmitting the arp
>request if it is dropped. The function neigh_event_send() does all this.
>Without doing full ND, rdma address resolution fails in the presence of
>dropped arp bcast packets.
>
>Signed-off-by: Steve Wise <swise@opengridcomputing.com>

Acked-by: Sean Hefty <sean.hefty@intel.com>

Roland - can you please queue this up for 2.6.24?
