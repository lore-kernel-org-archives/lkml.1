Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbYBOAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbYBOAA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758452AbYBOAAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:00:15 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59966 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbYBOAAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:00:14 -0500
Date: Fri, 15 Feb 2008 01:59:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ubi: fix sparse errors in ubi.h
Message-ID: <20080214235952.GI23227@cs181133002.pp.htv.fi>
References: <1203025995.5601.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1203025995.5601.0.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:53:15PM -0800, Harvey Harrison wrote:
> In C, signed 1-bit bitfields can only take the values 0 and -1, only
> 0 and 1 are ever assigned in current code.  Make them unsigned
> bitfields.
> 
> Fixes the (repeated) sparse errors:
> drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Sorry, not sure who to CC on this.
>...

$ grep UBI MAINTAINERS 
UNSORTED BLOCK IMAGES (UBI)
$ 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

