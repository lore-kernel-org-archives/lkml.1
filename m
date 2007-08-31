Return-Path: <linux-kernel-owner+w=401wt.eu-S966063AbXHaTVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966063AbXHaTVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964975AbXHaTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:20:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39791 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbXHaTUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:20:55 -0400
Date: Fri, 31 Aug 2007 21:20:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Starting point for deprecating "ether=" boot time
 option.
In-Reply-To: <Pine.LNX.4.64.0708311145150.13259@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708312119530.9413@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708311145150.13259@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 11:47, Robert P. J. Day wrote:
>diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
>index 12c7657..e4c3b26 100644
>--- a/net/ethernet/eth.c
>+++ b/net/ethernet/eth.c
>@@ -31,6 +31,8 @@
>  *				  older network drivers and IFF_ALLMULTI.
>  *	Christer Weinigel	: Better rebuild header message.
>  *             Andrew Morton    : 26Feb01: kill ether_setup() - use netdev_boot_setup().
>+ *             Robert P. J. Day : Add ether_boot_setup() to allow deprecation warning
>+				  for "ether=" boot-time option.

Though I welcome all obsoleting-related stuff,
"the file is not the changelog"; changes to into the SCM log.


	Jan
-- 
