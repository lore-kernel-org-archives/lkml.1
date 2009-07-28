Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZG1QIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZG1QIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZG1QIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:08:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZG1QIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:08:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=Icn0qDM763RY+1qTo5OmKxXLpYh9VreRkxWAm6iMXa9Lb4hO7rALm31sJOf0qmCBk
	EwD65OmrhKtJwRV9pc/zg==
Subject: [PATCH 0/2] IPVS: make use of pr_fmt and friends
To: lvs-devel@vger.kernel.org, netdev@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 28 Jul 2009 18:05:31 +0200
Message-ID: <20090728160145.12503.61834.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series makes use of pr_fmt and friends instead of printk.



Hannes Eder (2):
      IPVS: use pr_err and friends instead of IP_VS_ERR and friends
      IPVS: use pr_fmt


 include/net/ip_vs.h                     |  116 +++++++++++++++----------------
 net/netfilter/ipvs/ip_vs_app.c          |    3 +
 net/netfilter/ipvs/ip_vs_conn.c         |   15 ++--
 net/netfilter/ipvs/ip_vs_core.c         |   25 ++++---
 net/netfilter/ipvs/ip_vs_ctl.c          |   59 ++++++++--------
 net/netfilter/ipvs/ip_vs_dh.c           |    5 +
 net/netfilter/ipvs/ip_vs_est.c          |    4 +
 net/netfilter/ipvs/ip_vs_ftp.c          |    7 +-
 net/netfilter/ipvs/ip_vs_lblc.c         |    7 +-
 net/netfilter/ipvs/ip_vs_lblcr.c        |    9 ++
 net/netfilter/ipvs/ip_vs_lc.c           |    3 +
 net/netfilter/ipvs/ip_vs_nq.c           |    3 +
 net/netfilter/ipvs/ip_vs_proto.c        |    9 ++
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c |    7 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c    |    3 +
 net/netfilter/ipvs/ip_vs_proto_udp.c    |    3 +
 net/netfilter/ipvs/ip_vs_rr.c           |    3 +
 net/netfilter/ipvs/ip_vs_sched.c        |   39 ++++++----
 net/netfilter/ipvs/ip_vs_sed.c          |    3 +
 net/netfilter/ipvs/ip_vs_sh.c           |    5 +
 net/netfilter/ipvs/ip_vs_sync.c         |   49 +++++++------
 net/netfilter/ipvs/ip_vs_wlc.c          |    3 +
 net/netfilter/ipvs/ip_vs_wrr.c          |    5 +
 net/netfilter/ipvs/ip_vs_xmit.c         |    3 +
 24 files changed, 227 insertions(+), 161 deletions(-)
