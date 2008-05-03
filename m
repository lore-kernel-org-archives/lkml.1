Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYECViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYECViU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYECViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:38:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37442 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYECViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:38:09 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 04 May 2008 03:07:26 +0530
Message-Id: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 0/4] Add rlimit controller to cgroups (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of the address space control patches. These
patches are against 2.6.25-mm1  and have been tested using KVM in SMP mode,
both with and without the config enabled.

The first patch adds the user interface. The second patch fixes the
cgroup mm_owner_changed callback to pass the task struct, so that
accounting can be adjusted on owner changes. The thrid patch adds accounting
and control. The fourth patch updates documentation.

An earlier post of the patchset can be found at
http://lwn.net/Articles/275143/

This patch is built on top of the mm owner patches and utilizes that feature
to virtually group tasks by mm_struct.

Reviews, Comments?

Series

rlimit-controller-setup.patch
cgroup-add-task-to-mm--owner-callbacks.patch
rlimit-controller-address-space-accounting.patch
rlimit-controller-add-documentation.patch

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
