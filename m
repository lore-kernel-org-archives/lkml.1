Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZGSSZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZGSSZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZGSSY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:24:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2852 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZGSSY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:24:57 -0400
Subject: Re: [PATCH] drivers/net/mlx4: Adjust constant
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907191809050.16542@ask.diku.dk>
References: <Pine.LNX.4.64.0907191809050.16542@ask.diku.dk>
Content-Type: text/plain
Date: Sun, 19 Jul 2009 11:24:51 -0700
Message-Id: <1248027891.31365.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-19 at 18:09 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The values in the advertising field are typically ADVERTISED_xxx, not
> SUPPORTED_xxx.  Both SUPPORTED_10000baseT_Full and
> ADVERTISED_1000baseT_Full have the same value.

other possibles:

drivers/net/sungem.c:#define ADVERTISE_MASK	(SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full | \
			 SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full | \
			 SUPPORTED_1000baseT_Half | SUPPORTED_1000baseT_Full | \
			 SUPPORTED_Pause | SUPPORTED_Autoneg)
drivers/net/s2io.c:	info->advertising = (SUPPORTED_10000baseT_Full | SUPPORTED_FIBRE);
drivers/net/spider_net.c:		advertise |= SUPPORTED_1000baseT_Full;
drivers/net/spider_net.c:		advertise |= SUPPORTED_1000baseT_Half;


