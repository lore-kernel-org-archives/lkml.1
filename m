Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZKSIwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZKSIwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZKSIwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:52:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31937 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZKSIwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=BJL8tYUqcSDCmF8ecrCChnw3yQwAh03oNbq8CWgxcHy3IsF9zlkXdCsgKv38M8VxfD
         SKZQRdsCWfc1/7aFhXWUssHotJrne49WQgEaWN3cNYwp9XFSEQSJZV8gD/HtCFneNRcT
         wWzD3f5hkzOEZeTOtTS1lckZCvNjQErg+HSz4=
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 09:52:43 +0100
Message-ID: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
Subject: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am looking for the Asus Eeepc Poulsbo (psb) driver in Kernel
2.6.32-rc7. When is this driver expected to make it into the kernel?

At the moment I am getting following error:

 CC [M]  /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.o
  CC [M]  /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_bo.o
/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:
In function 'drm_ttm_ipi_handler':
/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:35:
error: implicit declaration of function 'flush_agp_cache'
/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:
In function 'drm_set_caching':
/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:116:
error: implicit declaration of function 'map_page_into_agp'
/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:118:
error: implicit declaration of function 'unmap_page_from_agp'
make[2]: *** [/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.o]
Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [_module_/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1]
Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.32-rc7'
make: *** [modules] Error 2
 * ERROR: x11-drivers/psb-kmod-4.41.1_p10 failed:
 *   (no error message)
 *
 * Call stack:
 *     ebuild.sh, line  49:  Called src_compile
 *   environment, line 3471:  Called die
 * The specific snippet of code:
 *       LINUXDIR=/usr/src/linux emake DRM_MODULES=psb || die
 *

When trying to use the driver from:

http://www.happyassassin.net/2009/09/26/gma-500-poulsbo-driver-for-fedora-11-soon-to-be-in-rpm-fusion/comment-page-1/#comment-1005

I would prefer to install the driver directly from the kernel.

Thank you for your Feedback.

Let me know if you need my .config.

Best
Zeno
