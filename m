Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbYCZSx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbYCZSx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbYCZSxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:53:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54464 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYCZSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:53:20 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 27 Mar 2008 00:19:54 +0530
Message-Id: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
Subject: [RFC][0/3] Virtual address space control for cgroups (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of the virtual address space control patchset
for cgroups.  The patches are against 2.6.25-rc5-mm1 and have been tested on
top of User Mode Linux, both with and without the config enabled.

The first patch adds the user interface. The second patch adds accounting
and control. The third patch updates documentation.

The changelog in each patchset documents what has changed in version 2.
The most important one being that virtual address space accounting is
now a config option.

Reviews, Comments?

series

memory-controller-virtual-address-space-control-user-interface
memory-controller-virtual-address-space-accounting-and-control
memory-controller-virtual-address-control-documentation



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
