Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbYEGGd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbYEGGd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbYEGGdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:33:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54533 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbYEGGdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:33:17 -0400
Date: Wed, 7 May 2008 09:32:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, gerg@uclinux.org
Subject: Re: [PATCH 6/6] m68knommu: remove example defconfig
Message-ID: <20080507063201.GB30082@cs181133002.pp.htv.fi>
References: <200805070125.m471PwNj023237@goober>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805070125.m471PwNj023237@goober>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:25:58AM +1000, Greg Ungerer wrote:

> Remove the old example m68knommu defconfig.
>...

Please use KBUILD_DEFCONFIG to define a default defconfig after this.

Simply add to arch/m68knommu/Makefile
  KBUILD_DEFCONFIG := m5208evb_defconfig
(replace m5208evb_defconfig with whichever you prefer).

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

