Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZIOQJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZIOQJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZIOQJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:09:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:33578 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbZIOQJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727157476"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:08:48 +0100
Subject: RE: [PATCH 10/18] ioat3: xor support
Thread-Topic: [PATCH 10/18] ioat3: xor support
Thread-Index: AcotK0pohYxYpiLHR+2JtF33HA+bXwI83uaw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548796@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
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
> ioat3.2 adds xor offload support for up to 8 sources.  It can also
> perform an xor-zero-sum operation to validate whether all given sources
> sum to zero, without writing to a destination.  Xor descriptors differ
> from memcpy in that one operation may require multiple descriptors
> depending on the number of sources.  When the number of sources exceeds
> 5 an extended descriptor is needed.  These descriptors need to be
> accounted for when updating the DMA_COUNT register.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>