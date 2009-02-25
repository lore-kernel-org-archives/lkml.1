Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbZBYUba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbZBYUba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZBYUbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:31:17 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:23314 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZBYUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:31:16 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/8] net: fix (sparse) warnings
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 21:31:10 +0100
Message-ID: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some (sparse) warnings in net/.

---

Hannes Eder (8):
      wanrouter: fix sparse warnings: context imbalance
      inet fragments: fix sparse warning: context imbalance
      decnet: fix sparse warnings: symbol shadows an earlier one
      decnet: fix sparse warnings: context imbalance
      [NET] sysctl: fix sparse warning: Should it be static?
      appletalk: fix warning: format not a string literal and no ...
      9p: fix sparse warning: cast adds address space
      net/802: fix sparse warnings: context imbalance


 include/net/inet_frag.h        |    3 ++-
 net/802/tr.c                   |    2 ++
 net/9p/trans_fd.c              |    2 +-
 net/appletalk/ddp.c            |    2 +-
 net/core/sysctl_net_core.c     |    1 +
 net/decnet/af_decnet.c         |   17 +++++++++--------
 net/decnet/dn_dev.c            |    3 ++-
 net/decnet/sysctl_net_decnet.c |    2 +-
 net/ipv4/inet_fragment.c       |    1 +
 net/wanrouter/wanmain.c        |    8 ++++++--
 net/wanrouter/wanproc.c        |    2 ++
 11 files changed, 28 insertions(+), 15 deletions(-)
