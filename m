Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYBKUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYBKUxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYBKUxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:53:20 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41512 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYBKUxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:53:20 -0500
Date: Mon, 11 Feb 2008 22:53:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove CONFIG_FORCE_INLINING from defconfigs
Message-ID: <20080211205311.GD2959@cs181133002.pp.htv.fi>
References: <1202761747.10004.11.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1202761747.10004.11.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 12:29:06PM -0800, Harvey Harrison wrote:
> Option has been removed as of:
> 185c045c245f46485ad8bbd8cc1100e986ff3f13 x86, core: remove CONFIG_FORCED_INLINING
>...

I'm not a fan of patching defconfig's this way - this will only bring 
tons of patch conflicts (consider what happens when anyone already has
a completely updated defconfig in his tree and your patch goes in first).

What you do manually already happens automatically when a maintainer 
updates a defconfig.

And for not regularly updated defconfigs one obsolete option more or 
less does not matter at all - even more since apart from a warning 
there's anyway no problem.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

