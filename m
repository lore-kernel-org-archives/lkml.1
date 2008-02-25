Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYBYP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYBYP46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYBYP4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:56:50 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41360 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYBYP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:56:49 -0500
Subject: 2.6.25-rc2-mm1 - boot hangs on ia64
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>
Cc: Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 25 Feb 2008 10:56:57 -0500
Message-Id: <1203955017.5046.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25-rc2-mm1 is hanging early in boot on my HP ia64 numa platform.  I saw
the "Strange hang on ia64 with CONFIG_PRINTK_TIME=y" thread on lkml:  

	http://marc.info/?t=120288396800001&r=1&w=4

However, my config does not include PRINTK_TIME=y.  In fact, hang occurs
with ia64 defconfig as well--right after the "Loading...initrd...done"
message.  2.6.25-rc2 boots OK.

Bisecting the broken-out series appears to indict 'git-sched.patch'.  I
went ahead and added Ingo's patch, discussed in the "strange hang"
thread, even tho' I hadn't enabled printk timestamps.  No effect.

Anyone else seeing this?

Regards,
Lee

