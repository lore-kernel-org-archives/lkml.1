Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYHOQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYHOQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYHOQLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:11:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:28303 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYHOQLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,216,1217833200"; 
   d="scan'208";a="34129370"
From: "Luck, Tony" <tony.luck@intel.com>
To: Robin Holt <holt@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Aug 2008 09:11:04 -0700
Subject: RE: ia64 allmodconfig on current mainline
Thread-Topic: ia64 allmodconfig on current mainline
Thread-Index: Acj+zqIIvRUOT7kOSjK5guh/zQGITQAIpt+A
Message-ID: <57C9024A16AD2D4C97DC78E552063EA309B828E1@orsmsx505.amr.corp.intel.com>
References: <20080812150608.231a948a.akpm@linux-foundation.org>
 <200808130022.50501.rjw@sisk.pl>
 <20080812155806.4e8554a9.akpm@linux-foundation.org>
 <57C9024A16AD2D4C97DC78E552063EA30844B247@orsmsx505.amr.corp.intel.com>
 <20080815120113.GN6824@sgi.com>
In-Reply-To: <20080815120113.GN6824@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> of per_cpu__kmem_cache_cpu at 0x28a0.  A couple other low-hanging fruit
> here are per_cpu__shadow_flush_counts and per_cpu__mmu_gathers each of
> which takes approx 16k.

Ah.  That perhaps explains the recent jump in usage that has put
allmodconfig over the limit.  mmu_gathers is an int[NR_CPUS], and
NR_CPUS was just raised from 1024 to 4096

-Tony
