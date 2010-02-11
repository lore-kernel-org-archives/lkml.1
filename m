Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0BKUA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:00:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:45654 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab0BKUA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,454,1262592000"; 
   d="scan'208";a="243125998"
Message-Id: <20100211195058.071883111@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Feb 2010 11:50:58 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com, suresh.b.siddha@intel.com
Subject: [patch v3 0/2] updated ptrace/core-dump patches for supporting xstate - v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:
a. Embrace the iov interface for PTRACE_GETREGSET/PTRACE_SETREGSET
b. fixes and coding style changes based on Roland and Oleg's feedback.

Changes from v1:
a. Split the patch into multiple patches.
b. Fix some bugs and coding style changes based on Roland's feedback.
c. Add generic PTRACE_GETREGSET/PTRACE_SETREGSET commands through which we can
   export the architecture specific regsets using the corresponding
   NT_* codes that userland is already aware of. The "xstate" regset is exported
   only using this interface.

thanks,
suresh

