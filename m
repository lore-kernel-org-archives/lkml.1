Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZAHPs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZAHPs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZAHPsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:48:47 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:33490 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZAHPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:48:46 -0500
X-BigFish: VPS-40(zz1432R62a3L98dR936eQ4015M1805Mzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KD5T8U-02-7ZH-01
Date: Thu, 8 Jan 2009 16:48:35 +0100
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
	IBM Cell processor
Message-ID: <20090108154835.GQ15411@erda.amd.com>
References: <1228177106.6509.285.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1228177106.6509.285.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 Jan 2009 15:48:35.0765 (UTC) FILETIME=[90FC0650:01C971A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.08 16:18:26, Carl Love wrote:
> This is a rework of the previously posted set of patches.
> 
> Patch 1 is the user level patch to add the SPU events to the user
> OProfile tool.  
> 
> Patch 2 is a kernel patch to do code clean up and restructuring to make
> it easier to add the new SPU event profiling support.  This patch makes
> no functional changes.
> 
> Patch 3 is a kernel patch to add the SPU event profiling support.

I applied patch 2 & 3 to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git cell

The patches did not apply cleanly. I had to change the path to
arch/powerpc/include/asm/, fix cell/pr_util.h and did some whitespace
cleanups. Please run your tests on the cell branch.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

