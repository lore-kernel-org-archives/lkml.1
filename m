Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZIOQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZIOQGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZIOQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:06:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:12600 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbZIOQGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727156790"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:04:59 +0100
Subject: RE: [PATCH 01/18] dmaengine: add fence support
Thread-Topic: [PATCH 01/18] dmaengine: add fence support
Thread-Index: AcotKy9Asil1dvLSRamAnuEBCUTJ6AI8v+Wg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548783@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064440.7141.72561.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064440.7141.72561.stgit@dwillia2-linux.ch.intel.com>
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
> Some engines optimize operation by reading ahead in the descriptor chain
> such that descriptor2 may start execution before descriptor1 completes.
> If descriptor2 depends on the result from descriptor1 then a fence is
> required (on descriptor2) to disable this optimization.  The async_tx
> api could implicitly identify dependencies via the 'depend_tx'
> parameter, but that would constrain cases where the dependency chain
> only specifies a completion order rather than a data dependency.  So,
> provide an ASYNC_TX_FENCE to explicitly identify data dependencies.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>