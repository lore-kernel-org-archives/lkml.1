Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZIOQHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZIOQHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZIOQG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:06:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:8861 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZIOQGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:06:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,391,1249282800"; 
   d="scan'208";a="187877783"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:06:52 +0100
Subject: RE: [PATCH 05/18] ioat2+: add fence support
Thread-Topic: [PATCH 05/18] ioat2+: add fence support
Thread-Index: AcotKzvhbeIX53r3R4iqHzsP0xHv6gI80BFw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554878E@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
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
> In preparation for adding more operation types to the ioat3 path the
> driver needs to honor the DMA_PREP_FENCE flag.  For example the async_tx api
> will hand xor->memcpy->xor chains to the driver with the 'fence' flag set on
> the first xor and the memcpy operation.  This flag in turn sets the 'fence'
> flag in the descriptor control field telling the hardware that future
> descriptors in the chain depend on the result of the current descriptor, so
> wait for all writes to complete before starting the next operation.
> 
> Note that ioat1 does not prefetch the descriptor chain, so does not
> require/support fenced operations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>