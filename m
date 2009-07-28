Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZG1Ryw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZG1Ryw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZG1Ryv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:54:51 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:26995
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753606AbZG1Ryv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:54:51 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz62a3L14c3Mzz1202hzzz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KNI727-03-D5A-01
Date: Tue, 28 Jul 2009 19:54:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] OProfile updates for tip
Message-ID: <20090728175407.GR14610@erda.amd.com>
Reply-To: 1248800846-25422-1-git-send-email-robert.richter@amd.com
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 28 Jul 2009 17:54:10.0911 (UTC) FILETIME=[694FCEF0:01CA0FAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull the latest oprofile branches into tip:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master
 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

See the shortlog below.

Note: The master branch contains all oprofile changes including the
  multiplexing patches. This branch is similar to tip/master and for
  testing, linux-next and integration. The core branch contains
  patches that should go upstream. Pull requests for Linus' tree will
  have commit ids from this branch.

-Robert


Jason Yeh (1):
      oprofile: Implement performance counter multiplexing

Robert Richter (27):
      x86/oprofile: Fix cast of counter value
      x86/oprofile: Rework and simplify nmi_cpu_setup()
      x86/oprofile: Whitespaces changes only
      x86/oprofile: Fix usage of NUM_CONTROLS/NUM_COUNTERS macros
      x86/oprofile: Use per_cpu() instead of __get_cpu_var()
      x86/oprofile: Fix initialization of switch_index
      oprofile: oprofile_set_timeout(), return with error for invalid args
      oprofile: Rename variable timeout_jiffies and move to oprofile_files.c
      oprofile: Remove oprofile_multiplexing_init()
      oprofile: Grouping multiplexing code in oprof.c
      oprofile: Introduce op_x86_phys_to_virt()
      oprofile: Grouping multiplexing code in op_model_amd.c
      x86/oprofile: Implement multiplexing setup/shutdown functions
      x86/oprofile: Moving nmi_setup_cpu_mux() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_save/restore_mpx_registers() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_switch() in nmi_int.c
      x86/oprofile: Remove const qualifier from struct op_x86_model_spec
      x86/oprofile: Remove unused num_virt_controls from struct op_x86_model_spec
      x86/oprofile: Modify initialization of num_virt_counters
      x86/oprofile: Add function has_mux() to check multiplexing support
      x86/oprofile: Enable multiplexing only if the model supports it
      x86/oprofile: Implement mux_clone()
      oprofile: Adding switch counter to oprofile statistic variables
      x86/oprofile: Implement op_x86_virt_to_phys()
      x86/oprofile: Add counter reservation check for virtual counters
      x86/oprofile: Small coding style fixes
      Merge branches 'oprofile/core', 'oprofile/urgent', 'oprofile/mux' and 'oprofile/master'; commit 'tip/x86/urgent'; commit 'tip/oprofile' into oprofile/master

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

