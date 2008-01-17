Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYAQXEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYAQXEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYAQXEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:04:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48445 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYAQXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:04:08 -0500
Date: Fri, 18 Jan 2008 00:04:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vince Fuller <vaf@cisco.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
In-Reply-To: <20080108011057.GA21168@cisco.com>
Message-ID: <Pine.LNX.4.64.0801180003330.18447@fbirervta.pbzchgretzou.qr>
References: <20080108011057.GA21168@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 7 2008 17:10, Vince Fuller wrote:
>--- net/ipv4/devinet.c.orig	2007-04-12 10:16:23.000000000 -0700
>+++ net/ipv4/devinet.c	2008-01-07 16:55:59.000000000 -0800
>@@ -594,6 +594,8 @@ static __inline__ int inet_abc_len(__be3
> 			rc = 16;
> 		else if (IN_CLASSC(haddr))
> 			rc = 24;
>+		else if (IN_CLASSE(haddr))
>+			rc = 24;
> 	}
> 
>   	return rc;

Any particular reason why 24?
