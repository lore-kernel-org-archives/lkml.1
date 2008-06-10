Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYFJOEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYFJOEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYFJOER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:04:17 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59175 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYFJOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:04:16 -0400
X-BigFish: VPS2(zzzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2932R-01-IMA-01
Date: Tue, 10 Jun 2008 16:04:11 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 0/5] x86: minor PAT adaptations
Message-ID: <20080610140411.GD5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:04:06.0000 (UTC) FILETIME=[D856CF00:01C8CB02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following some patches to slightly adapt the PAT code.

patch 1 - enable PAT for all AMD CPUs that have the PAT feature flag set
patch 2 - fix up paranoia check in pat_init and fix the logic to
          enable/disable PAT (IMHO the current code enables PAT on all
          Transmeta and Centaur CPUs even if no PAT feature flag is set) 
          (I admit I should have changed the sequence of patches 1 and 2.)
patch 3 - fix some checkpatch errors
patch 4 - variable renaming
patch 5 - slightly changing the code that is doing the intersection of
          pat_type and mtrr_type to be more readable (from my point of view)

Patches are against x86/pat (as of version v2.6.26-rc3-6-g46dd98a).

Please apply (at least patches 1 and 2).
Patches 3-5 are more a cleanup kind of thing.


Thanks.

Andreas


