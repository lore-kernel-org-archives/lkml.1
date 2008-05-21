Return-Path: <linux-kernel-owner+w=401wt.eu-S935998AbYEUPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998AbYEUPam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYEUPad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:30:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39430 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbYEUPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:30:31 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 May 2008 20:59:21 +0530
Message-Id: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 0/4] Add memrlimit controller (v5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth version of the address space control patches. These
patches are against 2.6.26-rc2-mm1  and have been tested using KVM in SMP mode,
both on a powerpc box

The goal of this patch is to implement a virtual address space controller
using cgroups. The documentation describes the controller, it's goal and
usage in further details.

Reviews, Comments?

Changelog

Patches [1/4] and [2/4] are unchanged
Patch [3/4] and [4/4] now formally use mmap_sem to protect mm->owner races.

Previous version of this patchset can be found at
http://lwn.net/Articles/282237/

Series

memrlimit-controller-add-documentation.patch
memrlimit-controller-setup.patch
cgroup-add-task-to-mm-owner-callbacks.patch
memrlimit-controller-address-space-accounting-and-control.patch

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
