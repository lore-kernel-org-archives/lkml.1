Return-Path: <linux-kernel-owner+w=401wt.eu-S965847AbXDIVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbXDIVMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXDIVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:12:38 -0400
Received: from [63.64.152.142] ([63.64.152.142]:1756 "EHLO gitlost.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965847AbXDIVMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:12:37 -0400
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH 0/2] REPOST: Multiqueue network device support
Date: Mon, 09 Apr 2007 14:27:23 -0700
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Message-Id: <20070409212723.31670.27976.stgit@gitlost.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting due to the patches getting bounced by majordomo:

This is a redesign and repost of the multiqueue network device support
patches.  The new API for base drivers allows multiqueue-capable devices to
manage their individual queues in the network stack.  The stack now handles
both non-multiqueue and multiqueue devices on the same codepath.  Also,
allocation and deallocation of the queues is handled by the kernel instead
of the driver.

Documentation is also included describing in more detail how this works, as
well as how a base driver can use the API to implement multiple queues.

These patches can also be pulled from my git repository at:

        git-pull git://lost.foo-projects.org/~ppwaskie/git/net-2.6.22 mq

--
Peter P. Waskiewicz Jr.
peter.p.waskiewicz.jr@intel.com
