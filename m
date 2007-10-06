Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXJFEmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXJFEmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 00:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXJFEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 00:42:24 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:36996 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXJFEmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 00:42:23 -0400
Date: Sat, 6 Oct 2007 00:42:21 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Matthew Reppert <arashi@sacredchao.net>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@linux.ie
Subject: Re: G33 graphics broken after 2.6.23-rc6
Message-ID: <20071006044221.GA14767@fattire.cabal.ca>
References: <4706D4B1.6050101@sacredchao.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4706D4B1.6050101@sacredchao.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 08:20:01PM -0400, Matthew Reppert wrote:
> It works fine in the Ubuntu kernels (pre 2.6.22-13) and in mainline through
> 2.6.23-rc6; since 2.6.23-rc7 (and Ubuntu 2.6.22-13), the X server won't
> start up, and I get this at the end of my Xorg.log:
> 

AOL. And I was in the middle of watching a bloody movie too.

commit f443675affe3f16dd428e46f0f7fd3f4d703eeab
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Sep 11 15:23:57 2007 -0700

    intel_agp: fix stolen mem range on G33
    
    G33 GTT stolen memory is below graphics data stolen memory and be seperate,
    so don't subtract it in stolen mem counting.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Acked-by: Dave Airlie <airlied@linux.ie>
    Cc: Dave Jones <davej@codemonkey.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Looks to be the commit that breaks things.

Regards,
	Kyle M.
