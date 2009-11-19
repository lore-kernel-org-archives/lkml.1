Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZKSO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZKSO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZKSO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:28:23 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31139 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZKSO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:28:22 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B055609.9030306@tremplin-utc.net>
Date: Thu, 19 Nov 2009 15:28:25 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
In-Reply-To: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 09:52, Zeno Davatz schreef:
> Hi
> 
> I am looking for the Asus Eeepc Poulsbo (psb) driver in Kernel
> 2.6.32-rc7. When is this driver expected to make it into the kernel?
> 
> At the moment I am getting following error:
> 
>  CC [M]  /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.o
>   CC [M]  /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_bo.o
> /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:
> In function 'drm_ttm_ipi_handler':
> /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:35:
> error: implicit declaration of function 'flush_agp_cache'
> /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:
> In function 'drm_set_caching':
> /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:116:
> error: implicit declaration of function 'map_page_into_agp'
> /var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.c:118:
> error: implicit declaration of function 'unmap_page_from_agp'
> make[2]: *** [/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1/drm_ttm.o]
> Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [_module_/var/tmp/portage/x11-drivers/psb-kmod-4.41.1_p10/work/psb-kernel-source-4.41.1]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.32-rc7'
> make: *** [modules] Error 2
Hi,
I'd also be interested by a patch to get the psb kernel module to
compile with 2.6.32. If anyone has this already available, please post it!
Or maybe someone knows what should be done to fix this type of errors?

Thanks,
Eric
