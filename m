Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYJMUVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYJMUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYJMUUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:20:51 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12607 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYJMUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:20:50 -0400
X-BigFish: VPS-8(zz62a3L4015Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K8P1U3-02-3D2-01
Date: Mon, 13 Oct 2008 22:20:23 +0200
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Oprofile kernel git tree
Message-ID: <20081013202022.GE23557@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Oct 2008 20:20:36.0621 (UTC) FILETIME=[2708C3D0:01C92D71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OProfile git tree is now up-to-date:

    git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git

Currently there are these branches:

Test branches (non fast-forward):

 master                  all patches
 next                    patches for next kernel


Feature branches (patches not yet ready for upstream, fast-forward only):

 arch-perfmon
 multiplexing


Upstream branches (patches for the architcture maintainers and
linux-next, fast-forward only):

 x86-oprofile-for-tip
 oprofile-for-tip
 powerpc-for-paul


Please use the master/next branches as the latest OProfile kernel for
testing.


Pending patches are:


powerpc-for-paul:

Carl Love (1):
      powerpc/cell/oprofile: fix mutex locking for spu-oprofile

Roel Kluin (1):
      powerpc/cell/oprofile: vma_map: fix test on overlay_tbl_offset


x86-oprofile-for-tip:

Andi Kleen (4):
      oprofile: drop const in num counters field
      oprofile: Don't report Nehalem as core_2
      oprofile: Implement Intel architectural perfmon support
      oprofile: discover counters for op ppro too


Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

