Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0BXBqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:46:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:49030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0BXBqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,528,1262592000"; 
   d="scan'208";a="495073472"
Message-Id: <20100224013858.506388000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Feb 2010 17:38:58 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Eric Paris <eparis@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Fixup rb_root initializations to use RB_ROOT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris found a problem with rb_root initializations and sent a patch to
fix it here:
http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/02946.html
btrfs: use RB_ROOT to intialize rb_trees instead of setting rb_node to NULL

Based on that, a simple grep for "rb_node = NULL" showed few more similar
usages in ext3, ext4 and jffs2. Here are the patches to fix those
root.rb_node = NULL
usages to
root = RB_ROOT

Compile tested.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

-- 

