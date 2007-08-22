Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbXHVX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbXHVX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbXHVX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:27:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:8125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762488AbXHVX1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,295,1183359600"; 
   d="scan'208";a="120453296"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Date: Wed, 22 Aug 2007 16:27:09 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023B2FD5@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070822231111.GD89849@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Thread-Index: AcflEb2dJHPmm0gxTCCh+Z81Lcy/wQAAZ71A
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com> <46CCB79E.7070109@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com> <20070822231111.GD89849@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jeremy Higdon" <jeremy@sgi.com>
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 22 Aug 2007 23:27:10.0670 (UTC) FILETIME=[F68996E0:01C7E513]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The more ioc's you have, the more space you will use.

Default SW IOTLB allocation is 64MB ... how much should we see
used per ioc?

Kamelesh: You could try increasing the amount of sw iotlb space
available by booting with a swiotlb=131072 argument (argument
value is the number of 2K slabs to allocate ... 131072 would
give you four times as much space as the default allocation).

-Tony
