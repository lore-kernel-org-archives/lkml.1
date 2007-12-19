Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXLSF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXLSF3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXLSF3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:29:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:44473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXLSF3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="448789053"
Date: Wed, 19 Dec 2007 13:20:30 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       "Gross, Mark" <mark.gross@intel.com>
Subject: [agp-mm][PATCH 0/4] enabling graphics memory dma remapping
Message-ID: <20071219052030.GA24238@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
	"Gross, Mark" <mark.gross@intel.com>
References: <20071218050809.GA12564@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218050809.GA12564@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.18 13:08:09 +0000, Zhenyu Wang wrote:
> 
> Here're three patches below:
> 
> - intel_iommu-explicit-export-current-graphics-dmar-status.patch
>   
>   This exports current status of graphics dma remap engine, which
>   depends on current platform iommu support, kernel config or runtime
>   config. This info will be used in agp module for detect whether
>   we should do remapping or not.
> 
> - AGP-Add-generic-support-for-graphics-dma-remapping.patch
> 
>   This adds new hooks into agp bridge driver to do map/unmap when
>   bind/unbind memory into GART table. The aim is to provide generic
>   interfaces to let driver implement hardware specific operations.
> 
> - AGP-intel_agp-add-support-for-graphics-dma-remapping.patch
> 
>   This implements graphics dma remapping support in intel_agp module,
>   current only desktop chipset G33 series can use it.

Above patch series are against master branch, following threads try to
rebase them to Airlie's agp-mm tree for -mm inclusion.

Thanks.
