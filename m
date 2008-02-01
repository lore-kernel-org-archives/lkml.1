Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYBAOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYBAOrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYBAOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:47:16 -0500
Received: from ns2.optonet.cz ([78.156.128.11]:2568 "EHLO on-dns-srv02"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbYBAOrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:47:15 -0500
X-Greylist: delayed 1277 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 09:47:14 EST
Message-ID: <47A32BEB.9040008@gmail.com>
Date: Fri, 01 Feb 2008 15:25:47 +0100
From: Jiri Moravec <jim.lkml@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071027)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Typo in net/netfilter/xt_iprange.c (git tree)
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2008 14:25:51.0849 (UTC) FILETIME=[58FC0D90:01C864DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function iprange_mt4 belong to IPv4 family - AF_INET. Right?

	.name      = "iprange",
	.revision  = 1,
	.family    = AF_INET6, <---------- Typo?
	.match     = iprange_mt4,
	.matchsize = sizeof(struct xt_iprange_mtinfo),
	.me        = THIS_MODULE,



