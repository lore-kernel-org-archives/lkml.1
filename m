Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZIOQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZIOQJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZIOQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:09:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:25840 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZIOQJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727157417"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:07:40 +0100
Subject: RE: [PATCH 07/18] ioat3: split ioat3 support to its own file, add
 memset
Thread-Topic: [PATCH 07/18] ioat3: split ioat3 support to its own file, add
 memset
Thread-Index: AcotK0wVVtsbMhxmRBK7Ort8qZmYuAI81E5A
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548793@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064510.7141.80671.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064510.7141.80671.stgit@dwillia2-linux.ch.intel.com>
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
> Up until this point the driver for Intel(R) QuickData Technology
> engines, specification versions 2 and 3, were mostly identical save for
> a few quirks.  Version 3.2 hardware adds many new capabilities (like
> raid offload support) requiring some infrastructure that is not relevant
> for v2.  For better code organization of the new funcionality move v3
> and v3.2 support to its own file dma_v3.c, and export some routines from
> the base files (dma.c and dma_v2.c) that can be reused directly.
> 
> The first new capability included in this code reorganization is support
> for v3.2 memset operations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>