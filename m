Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZKZRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZKZRLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZKZRLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:11:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36193 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbZKZRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:11:20 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v0 0/3] cgroup notifications API and memory thresholds
Date: Thu, 26 Nov 2009 19:11:14 +0200
Message-Id: <cover.1259255307.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's my first attempt to implement cgroup notifications API and memory
thresholds on top of it. The idea of API was proposed by Paul Menage.

It lacks some important features and need more testing, but I want publish
it as soon as possible to get feedback from community.

TODO:
 - memory thresholds on root cgroup;
 - memsw support;
 - documentation.

Kirill A. Shutemov (3):
  cgroup: implement eventfd-based generic API for notifications
  res_counter: implement thresholds
  memcg: implement memory thresholds

 include/linux/cgroup.h      |    8 ++
 include/linux/res_counter.h |   44 +++++++++++
 kernel/cgroup.c             |  181 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/res_counter.c        |    4 +
 mm/memcontrol.c             |  149 +++++++++++++++++++++++++++++++++++
 5 files changed, 385 insertions(+), 1 deletions(-)

