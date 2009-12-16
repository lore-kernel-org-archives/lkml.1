Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbZLPVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbZLPVP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZLPVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:15:58 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53110 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZLPVP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:15:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vsZ8fFZfTaHpzzrfpqUVXdeGWnwb45fPlRY/FQnPnZlNRMfrlEMLQbt1BDVyiq3tE/
         avZtO/NgHH/sxqosK7dP0ReD6q4kXTkhgOKjpu3/vDWDVe8TgmwoDyuSvTtN4s8czIHS
         q1+4eSBBKbIVhGmpj/gWldBz6jqgxz/HrQTKg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0912142253450.24200@skynet.skynet.ie>
References: <alpine.DEB.2.00.0912142253450.24200@skynet.skynet.ie>
Date: Thu, 17 Dec 2009 07:15:56 +1000
Message-ID: <21d7e9970912161315vb667f56ua685a7403f9e4c60@mail.gmail.com>
Subject: Re: [git pull] vmware drm/kms driver under staging
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Linus,
>
> Please pull the 'drm-vmware-staging' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-vmware-staging

ping?

Greg is fine with this going in, and its a pretty standalone driver
for a very popular virtual GPU.

Dave.

>
> This adds the VMware KMS driver for their virtual GPU, the Kconfig is
> under staging until they are happy with the ioctl interface to the 3D
> driver, which may be quite soon.
>
> We now have 4 KMS drivers, hopefully it'll quieten down for a while, while
> we fix them all up.
>
> Dave.
>
>  drivers/gpu/drm/Makefile                 |    1 +
>  drivers/gpu/drm/vmwgfx/Kconfig           |   13 +
>  drivers/gpu/drm/vmwgfx/Makefile          |    9 +
>  drivers/gpu/drm/vmwgfx/svga3d_reg.h      | 1793 ++++++++++++++++++++++++++++++
>  drivers/gpu/drm/vmwgfx/svga_escape.h     |   89 ++
>  drivers/gpu/drm/vmwgfx/svga_overlay.h    |  201 ++++
>  drivers/gpu/drm/vmwgfx/svga_reg.h        | 1346 ++++++++++++++++++++++
>  drivers/gpu/drm/vmwgfx/svga_types.h      |   45 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c   |  229 ++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |  735 ++++++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |  511 +++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  |  516 +++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c       |  742 ++++++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |  521 +++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c      |  213 ++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |   81 ++
>  drivers/gpu/drm/vmwgfx/vmwgfx_irq.c      |  295 +++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c      |  872 +++++++++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.h      |  102 ++
>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c      |  516 +++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c  |  634 +++++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_reg.h      |   57 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_resource.c | 1192 ++++++++++++++++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c |   99 ++
>  drivers/staging/Kconfig                  |    2 +
>  include/drm/Kbuild                       |    1 +
>  include/drm/ttm/ttm_object.h             |    6 +-
>  include/drm/vmwgfx_drm.h                 |  574 ++++++++++
>  28 files changed, 11394 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/gpu/drm/vmwgfx/Kconfig
>  create mode 100644 drivers/gpu/drm/vmwgfx/Makefile
>  create mode 100644 drivers/gpu/drm/vmwgfx/svga3d_reg.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/svga_escape.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/svga_overlay.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/svga_reg.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/svga_types.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_reg.h
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
>  create mode 100644 include/drm/vmwgfx_drm.h
>
> commit fb1d9738ca053ea8afa5e86af6463155f983b01c
> Author: Jakob Bornecrantz <jakob@vmware.com>
> Date:   Thu Dec 10 00:19:58 2009 +0000
>
>    drm/vmwgfx: Add DRM driver for VMware Virtual GPU
>
>    This commit adds the vmwgfx driver for the VWware Virtual GPU aka SVGA.
>    The driver is under staging the same as Nouveau and Radeon KMS. Hopefully
>    the 2D ioctls are bug free and don't need changing, so that part of the
>    API should be stable. But there there is a pretty big chance that the 3D API
>    will change in the future.
>
>    Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
>    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 632f61178d0473861ba77e774bb654b37bc7eccc
> Author: Jakob Bornecrantz <jakob@vmware.com>
> Date:   Thu Dec 10 00:19:10 2009 +0000
>
>    drm/vmwgfx: Add svga headers for vmwgfx driver
>
>    These headers are shared between multiple place where
>    different coding standards apply. They will be fixed
>    up at a later time.
>
>    Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
>    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit be1cb8689c480228ffd2e4bfccc0dab7156cd9ea
> Author: Jakob Bornecrantz <jakob@vmware.com>
> Date:   Mon Dec 14 22:07:45 2009 +0000
>
>    drm/ttm: Add more driver type enums
>
>    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
