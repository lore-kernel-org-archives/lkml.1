Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYDPRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYDPRvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYDPRvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:51:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57684 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYDPRvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:51:41 -0400
Date: Wed, 16 Apr 2008 20:51:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416175135.GN1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

although DEBUG_SECTION_MISMATCH allows to also find exotig things like 
finding bugs only present when using gcc < 3.4 and CONFIG_HOTPLUG=n at 
the same time, the problem is that we print
    WARNING: modpost: Found 13 section mismatch(es).
    To see full details build your kernel with:
    'make CONFIG_DEBUG_SECTION_MISMATCH=y'
but CONFIG_DEBUG_SECTION_MISMATCH is not offered in 2.6.25.

The options seem to be:
- going back to the worse but for most practical purposes usable
  warnings in 2.6.24
- don't show these warnings during modpost for 2.6.25

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

