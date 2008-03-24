Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYCXVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYCXVZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYCXVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:25:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:34040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbYCXVZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,548,1199692800"; 
   d="scan'208";a="539228661"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: larger default page sizes...
Date: Mon, 24 Mar 2008 14:25:11 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE5B88C@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080324.133722.38645342.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: larger default page sizes...
Thread-Index: AciN728eq6KPx3WhQqCUnzLsZqR4aQABXhUw
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com><20080321.145712.198736315.davem@davemloft.net><Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com> <20080324.133722.38645342.davem@davemloft.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Miller" <davem@davemloft.net>, <clameter@sgi.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 24 Mar 2008 21:25:12.0182 (UTC) FILETIME=[8B313160:01C88DF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The memory wastage is just rediculious.

In an ideal world we'd have variable sized pages ... but
since most arcthitectures have no h/w support for these
it may be a long time before that comes to Linux.

In a fixed page size world the right page size to use
depends on the workload and the capacity of the system.

When memory capacity is measured in hundreds of GB, then
a larger page size doesn't look so ridiculous.

-Tony
