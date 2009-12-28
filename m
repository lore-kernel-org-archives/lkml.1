Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZL1QIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZL1QIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZL1QIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:08:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:43800 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbZL1QIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:08:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,463,1257148800"; 
   d="scan'208";a="582574951"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "stable@kernel.org" <stable@kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Dec 2009 16:08:47 +0000
Subject: RE: [PATCH 1/3] ioat3: fix p-disabled q-continuation
Thread-Topic: [PATCH 1/3] ioat3: fix p-disabled q-continuation
Thread-Index: AcqDZqmseKv08O5pSPeQk12u/Yr5gwEcUR9g
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710B9@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002555.32335.85860.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091223002555.32335.85860.stgit@dwillia2-linux.ch.intel.com>
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
> When continuing a pq calculation the driver needs 3 extra sources.  The
> driver can perform a 3 source calculation with a single descriptor, but
> needs an extended descriptor to process up to 8 sources in one
> operation.  However, in the p-disabled case only one extra source is
> needed.  When continuing a p-disabled operation there are occasions
> (i.e. 0 < src_cnt % 8 < 3) where the tail operation does not need an
> extended descriptor.  Properly account for this fact otherwise invalid
> 'dmacount' values will be written to hardware usually causing the
> channel to halt with 'invalid descriptor' errors.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
