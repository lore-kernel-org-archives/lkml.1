Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZIUL70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZIUL70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZIUL7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:59:23 -0400
Received: from mail001.aei.ca ([206.123.6.130]:42337 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZIUL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:59:22 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm tree.
Date: Mon, 21 Sep 2009 07:59:21 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31.1-rc1-crc; KDE/4.2.4; x86_64; ; )
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909210759.22008.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 September 2009 01:12:54 Dave Airlie wrote:
> 
> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 
> This contains the main chunk of the drm changes for 2.6.32, I think Eric 
> has been on holidays for a week so I'd expect some more Intel changes 
> incoming in the merge window. It also contains a few merges for things 
> that were conflicting with things I sent to you via the drm-fixes tree,
> but they weren't always trivial.
> 
> Major highlights core drm/non-kms:
> move mga/r128/radeon to firmware loader - major LOC churn,
> decreases in-memory radeon module footprint quite a bit.
> r600 3D support in non-kms mode.

Dave,

What user space stuff (xorg/mesa) is required to use the R300 3D?

TIA,
Ed Tomlinson

> VGA arbitration support for core drm and kms (was waiting for
> jbarnes tree to land).
> 
> core KMS:
> add support for GTF/CVT/DMT modes, gets us a long way towards X
> merge intel and radeon kms framebuffer implementations for sanity.
> 
> radeon KMS:
> R600 KMS support + acceleration support.
> move to generating the safe register tables with a script.
> radeon tv-out supported ported from userspace
> rn50/r100/r200 command submission trackers added
> 
> intel: 
> some IGDNG fixes
> important fix for wrapping at end of ring
> more SDVO tv-out support
> dynamic clocking support
>
