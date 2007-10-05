Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbXJEIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbXJEIbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 04:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXJEIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 04:30:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39145 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025AbXJEIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 04:30:57 -0400
Date: Fri, 5 Oct 2007 10:31:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: werner <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug in drm  modules of kernel 2.6.23-rc9-git2
Message-ID: <20071005083122.GH10852@stusta.de>
References: <1191565675.4842@copaya.yi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1191565675.4842@copaya.yi.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 03:27:55AM -0300, werner wrote:
> attn:  linux-kernel@vger.kernel.org
> 
> 
> There is a bug in the drm modules,  w.r.t. radeon and savage grafic cards (at least)
> This bug is present on kernel 2.6.23-rc9-git2 ,  it was NOT present on 2.6.23-rc8-git4
> nor in the previous kernels.   Without drm, also compiz snapshot don't work longer
> 
> I hope you can find and repair this before the 2.6.23 release
> 
> Below is the beginning of dmesg  for the two kernels what I quoted above.
> 
> Werner Landgraf
> www.copaya.yi.org
> 
> 
> ==============  dmesg 2.6.23-rc9-git2 (drm no working longer ...) ===================================
> Linux version 2.6.23-rc9-git2-i486-1mn (root@werner) (gcc version 4.2.0 20061031 (prerelease)) #1 SMP Thu Oct 4 15:32:50 GFT 2007
>...
> via_agp: Unknown symbol agp_bridge
> via_agp: Unknown symbol agp3_generic_sizes
> via_agp: Unknown symbol global_cache_flush
> via_agp: Unknown symbol agp_generic_enable
> via_agp: Unknown symbol agp_generic_insert_memory
> via_agp: Unknown symbol agp_generic_destroy_page
> via_agp: Unknown symbol agp_off
> via_agp: Unknown symbol agp_remove_bridge
> via_agp: Unknown symbol agp_generic_mask_memory
> via_agp: Unknown symbol agp_generic_alloc_by_type
> via_agp: Unknown symbol agp_generic_free_by_type
> via_agp: Unknown symbol agp_alloc_bridge
> via_agp: Unknown symbol agp_add_bridge
> via_agp: Unknown symbol get_agp_version
> via_agp: Unknown symbol agp_generic_remove_memory
> via_agp: Unknown symbol agp_generic_create_gatt_table
> via_agp: Unknown symbol agp_generic_type_to_mask_type
> via_agp: Unknown symbol agp_generic_free_gatt_table
> via_agp: Unknown symbol agp_generic_alloc_page
> via_agp: Unknown symbol agp_put_bridge
>...

The agpgart module is not present.

This indicates that something went wrong with building or installing 
your modules.

Is it still present if you wipe the 2.6.23-rc9-git2 sources, image and 
modules from your disk, freshly unpack the sources, recompile the 
kernel and install the modules?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

