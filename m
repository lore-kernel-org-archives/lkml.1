Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065Ab0AEGmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0AEGmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873Ab0AEGmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:42:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48564
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab0AEGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:42:15 -0500
Date: Mon, 04 Jan 2010 22:42:18 -0800 (PST)
Message-Id: <20100104.224218.35346973.davem@davemloft.net>
To: rakesh@chelsio.com
Cc: michaelc@cs.wisc.edu, open-iscsi@googlegroups.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de, kxie@chelsio.com
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B01577E.2020003@chelsio.com>
References: <4B014F95.8000906@chelsio.com>
	<20091116.051835.125328285.davem@davemloft.net>
	<4B01577E.2020003@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Ranjan <rakesh@chelsio.com>
Date: Mon, 16 Nov 2009 19:15:34 +0530

> +	/* Construct UDP header */
> +	udph = &pkt->udph;
> +	udph->source = htons(DHCPC_CLIENT_PORT);
> +	udph->dest = htons(DHCPC_SERVER_PORT);
> +	udph->len = htons(sizeof(struct dhcp_pkt) - sizeof(struct iphdr));

UDP checksum is not set, and is also not validated on receive.
