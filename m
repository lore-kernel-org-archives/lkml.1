Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbXEQWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbXEQWsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXEQWsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:48:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:61866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbXEQWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:48:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229295778"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drm modesetting core
Date: Thu, 17 May 2007 15:48:14 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171537.46639.jesse.barnes@intel.com>
In-Reply-To: <200705171537.46639.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171548.15199.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007 3:37 pm Jesse Barnes wrote:
> This patch adds the core of the new DRM based modesetting system.  It
> creates several new structures in the DRM, the primary ones being the
> CRTC, which controls all aspects of your device's CRTC(s), output,
> which describes and controls the various outputs on your gfx chip
> (e.g. TMDS, LVDS, VGA, etc.), and mode, which describes graphics
> modes in enough detail for the output and CRTC callbacks to program
> them to hardware.
>
> It also contains the user level IOCTL interfaces for doing graphics
> programming (getting CRTC, output and mode lists, setting up new
> frame buffer objects, etc.).
>
> It relies on the new TTM patch Dave posted recently.

 Makefile.kernel |    6
 drmP.h          |   11
 drm_bo.c        |    8
 drm_bo_move.c   |    2
 drm_bufs.c      |    3
 drm_compat.h    |    7
 drm_crtc.c      | 1652 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drm_crtc.h      |  535 ++++++++++++++++++
 drm_drv.c       |   92 ---
 drm_edid.c      |  467 +++++++++++++++
 drm_edid.h      |  176 +++++
 drm_fb.c        |  201 ++++++
 drm_fops.c      |    4
 drm_modes.c     |  558 ++++++++++++++++++
 drm_objects.h   |   22
 drm_os_linux.h  |   18
 drm_stub.c      |   21
 drm_vm.c        |    5
 18 files changed, 3695 insertions(+), 93 deletions(-)
