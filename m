Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbYDVU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbYDVU5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762911AbYDVU5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:57:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:15878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762786AbYDVU5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,696,1199692800"; 
   d="scan'208";a="555798158"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Patch 1/4] move XP and XPC to drivers/misc/sgi-xp -v4
Date: Tue, 22 Apr 2008 13:57:30 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012AF3D7@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080422194656.GA14628@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/4] move XP and XPC to drivers/misc/sgi-xp -v4
Thread-Index: Aciksammli5Wt11PSNOWfGGaft1thgACO2Zg
References: <20080422194459.GB13086@sgi.com> <20080422194656.GA14628@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Dean Nelson" <dcn@sgi.com>
Cc: <jes@sgi.com>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2008 20:57:31.0952 (UTC) FILETIME=[7B98F300:01C8A4BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Move XPC and XPNET from arch/ia64/sn/kernel to drivers/misc/sgi-xp.

Dean,

I applied this series on top of this morning's patch to change
the uncached allocator to support multiple page allocations.

Now I see errors in the build because xpc_partition.c doesn't
have the matching change to support the extra argument:

drivers/misc/sgi-xp/xpc_partition.c: In function `xpc_rsvd_page_init':
drivers/misc/sgi-xp/xpc_partition.c:214: error: too few arguments to function `uncached_alloc_page'
drivers/misc/sgi-xp/xpc_partition.c:233: error: too few arguments to function `uncached_free_page'

-Tony
