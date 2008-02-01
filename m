Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYBATLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYBATLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYBATL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:11:27 -0500
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:53794 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643AbYBATLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:11:24 -0500
To: netdev@vger.kernel.org
Subject: Re: Typo in net/netfilter/xt_iprange.c (git tree)
Cc: jim.lkml@gmail.com, linux-kernel@vger.kernel.org
In-reply-To: <47A32BEB.9040008@gmail.com>
References: <47A32BEB.9040008@gmail.com>
Message-Id: <E1JL1II-0002Qy-9u@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 01 Feb 2008 20:11:22 +0100
X-OriginalArrivalTime: 01 Feb 2008 19:11:22.0323 (UTC) FILETIME=[3B8AF230:01C86506]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward to netdev list.

--------------- Forwarded message (begin)
Subject: Typo in net/netfilter/xt_iprange.c (git tree)
From: Jiri Moravec <...>
Date: Fri, 01 Feb 2008 15:50:15 +0100

Function iprange_mt4 belong to IPv4 family - AF_INET. Right?

	.name      = "iprange",
	.revision  = 1,
	.family    = AF_INET6, <---------- Typo?
	.match     = iprange_mt4,
	.matchsize = sizeof(struct xt_iprange_mtinfo),
	.me        = THIS_MODULE,
--------------- Forwarded message (end)
