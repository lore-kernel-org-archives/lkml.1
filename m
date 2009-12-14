Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZLNW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZLNW4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbZLNW4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:56:15 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49421 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbZLNW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:56:14 -0500
Date: Mon, 14 Dec 2009 22:56:07 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] vmware drm/kms driver under staging
Message-ID: <alpine.DEB.2.00.0912142253450.24200@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-365326625-1260831367=:24200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-365326625-1260831367=:24200
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-vmware-staging' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-vmware-staging

This adds the VMware KMS driver for their virtual GPU, the Kconfig is 
under staging until they are happy with the ioctl interface to the 3D 
driver, which may be quite soon.

We now have 4 KMS drivers, hopefully it'll quieten down for a while, while
we fix them all up.

Dave.

 drivers/gpu/drm/Makefile                 |    1 +
 drivers/gpu/drm/vmwgfx/Kconfig           |   13 +
 drivers/gpu/drm/vmwgfx/Makefile          |    9 +
 drivers/gpu/drm/vmwgfx/svga3d_reg.h      | 1793 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/svga_escape.h     |   89 ++
 drivers/gpu/drm/vmwgfx/svga_overlay.h    |  201 ++++
 drivers/gpu/drm/vmwgfx/svga_reg.h        | 1346 ++++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/svga_types.h      |   45 +
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c   |  229 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |  735 ++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |  511 +++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  |  516 +++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c       |  742 ++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |  521 +++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c      |  213 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |   81 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c      |  295 +++++
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c      |  872 +++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h      |  102 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c      |  516 +++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c  |  634 +++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_reg.h      |   57 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c | 1192 ++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c |   99 ++
 drivers/staging/Kconfig                  |    2 +
 include/drm/Kbuild                       |    1 +
 include/drm/ttm/ttm_object.h             |    6 +-
 include/drm/vmwgfx_drm.h                 |  574 ++++++++++
 28 files changed, 11394 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/drm/vmwgfx/Kconfig
 create mode 100644 drivers/gpu/drm/vmwgfx/Makefile
 create mode 100644 drivers/gpu/drm/vmwgfx/svga3d_reg.h
 create mode 100644 drivers/gpu/drm/vmwgfx/svga_escape.h
 create mode 100644 drivers/gpu/drm/vmwgfx/svga_overlay.h
 create mode 100644 drivers/gpu/drm/vmwgfx/svga_reg.h
 create mode 100644 drivers/gpu/drm/vmwgfx/svga_types.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_reg.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
 create mode 100644 include/drm/vmwgfx_drm.h

commit fb1d9738ca053ea8afa5e86af6463155f983b01c
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Thu Dec 10 00:19:58 2009 +0000

    drm/vmwgfx: Add DRM driver for VMware Virtual GPU
    
    This commit adds the vmwgfx driver for the VWware Virtual GPU aka SVGA.
    The driver is under staging the same as Nouveau and Radeon KMS. Hopefully
    the 2D ioctls are bug free and don't need changing, so that part of the
    API should be stable. But there there is a pretty big chance that the 3D API
    will change in the future.
    
    Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 632f61178d0473861ba77e774bb654b37bc7eccc
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Thu Dec 10 00:19:10 2009 +0000

    drm/vmwgfx: Add svga headers for vmwgfx driver
    
    These headers are shared between multiple place where
    different coding standards apply. They will be fixed
    up at a later time.
    
    Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit be1cb8689c480228ffd2e4bfccc0dab7156cd9ea
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Mon Dec 14 22:07:45 2009 +0000

    drm/ttm: Add more driver type enums
    
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-365326625-1260831367=:24200--
