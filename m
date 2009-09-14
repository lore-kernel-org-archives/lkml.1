Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZINPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZINPCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZINPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:02:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:34269 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbZINPCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="187386787"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 16:02:37 +0100
Subject: RE: [PATCH 29/29] ioat2,	3: cacheline align software descriptor
 allocations
Thread-Topic: [PATCH 29/29] ioat2,	3: cacheline align software descriptor
 allocations
Thread-Index: AcotCAaPgnXTQr4TS/eLPpow/YEUGQIRFAZA
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554819B@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023257.32667.53926.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023257.32667.53926.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> All the necessary fields for handling an ioat2,3 ring entry can fit into
> one cacheline.  Move ->len prior to ->txd in struct ioat_ring_ent, and
> move allocation of these entries to a hw-cache-aligned kmem cache to
> reduce the number of cachelines dirtied for descriptor management.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
