Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXEQWtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXEQWtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbXEQWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:48:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:59737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbXEQWsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:48:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229295894"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Intel support for DRM modesetting
Date: Thu, 17 May 2007 15:48:43 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171540.31433.jesse.barnes@intel.com>
In-Reply-To: <200705171540.31433.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171548.43344.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007 3:40 pm Jesse Barnes wrote:
> This patch adds support for DRM modesetting to the Intel DRM driver
> and stubs out a simple FB driver to sit underneath.  The code had to
> be refactored a bit, since current DRM drivers tend to be fully
> initialized by userspace via ioctls.  This patch makes the driver
> load routine do most of the heavy lifting, since it's necessary in
> order to fully bring up a console driver.
>
> It also relies on the TTM patch Dave posted recently for allocating
> the initial framebuffer used by the FB layer.

 i915_drv.c        |    2
 i915_init.c       |  305 +++++++++++++
 intel_crt.c       |  248 ++++++++++
 intel_display.c   | 1232 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 intel_drv.h       |   79 +++
 intel_i2c.c       |  187 ++++++++
 intel_lvds.c      |  500 +++++++++++++++++++++
 intel_modes.c     |   55 ++
 intel_sdvo.c      | 1095 +++++++++++++++++++++++++++++++++++++++++++++++
 intel_sdvo_regs.h |  328 ++++++++++++++
 10 files changed, 4030 insertions(+), 1 deletion(-)
