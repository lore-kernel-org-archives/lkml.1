Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbZE2NoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbZE2NoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbZE2Nmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:56748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189AbZE2Nmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="519893806"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:41:55 +0100
Subject: RE: [PATCH v2 06/11] async_tx: add sum check flags
Thread-Topic: [PATCH v2 06/11] async_tx: add sum check flags
Thread-Index: AcnZIoYpUKOLCiGmSEy05L3hUh5H3gHN0tUA
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C70@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005956.4104.27783.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200111p54382735v6941b52825cf4d7e@mail.gmail.com>
In-Reply-To: <f12847240905200111p54382735v6941b52825cf4d7e@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> Replace the flat zero_sum_result with a collection of flags to contain
> the P (xor) zero-sum result, and the soon to be utilized Q (raid6 reed
> solomon syndrome) zero-sum result.  Use the SUM_CHECK_ namespace instead
> of DMA_ since these flags will be used on non-dma-zero-sum enabled
> platforms.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/arm/include/asm/hardware/iop3xx-adma.h |    5 +++--
>  arch/arm/mach-iop13xx/include/mach/adma.h   |   12 +++++++-----
>  crypto/async_tx/async_xor.c                 |    4 ++--
>  drivers/md/raid5.c                          |    2 +-
>  drivers/md/raid5.h                          |    5 +++--
>  include/linux/async_tx.h                    |    2 +-
>  include/linux/dmaengine.h                   |   21 ++++++++++++++++++++-
>  7 files changed, 37 insertions(+), 14 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>