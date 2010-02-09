Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0BIU2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:28:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:25765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0BIU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:28:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,438,1262592000"; 
   d="scan'208";a="594501524"
Message-Id: <20100209201309.902050211@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 09 Feb 2010 12:13:09 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: [patch v2 0/4] updated ptrace/core-dump patches for supporting xstate - V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches are on top of the -tip/master tree.
First patch in the series reverts the first version of the patch that went into
the -tip tree.

Changes from v1:
a. Split the patch into multiple patches.
b. Fix some bugs and coding style changes based on Roland's feedback.
c. Add generic PTRACE_GETREGSET/PTRACE_SETREGSET commands through which we can
   export the architecture specific regsets using the corresponding
   NT_* codes that userland is already aware of. The "xstate" regset is exported
   only using this interface.

thanks,
suresh

