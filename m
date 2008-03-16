Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYCPRbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYCPRbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 13:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPRbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 13:31:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41676 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCPRbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 13:31:15 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 16 Mar 2008 22:59:42 +0530
Message-Id: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
Subject: [RFC][0/3] Virtual address space control for cgroups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an early patchset for virtual address space control for cgroups.
The patches are against 2.6.25-rc5-mm1 and have been tested on top of
User Mode Linux.

The first patch adds the user interface. The second patch adds accounting
and control. The third patch updates documentation.

Review suggestions would be appreciated along the lines of

1. What is missing? Are all virtual address space expansion points covered?
2. Do we need to account and control address space at insert_special_mapping?
3. Address space accounting may contain duplications. Do we need to avoid it?

Comments?

series

memory-controller-virtual-address-space-control-user-interface
memory-controller-virtual-address-space-accounting-and-control
memory-controller-virtual-address-control-documentation



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
