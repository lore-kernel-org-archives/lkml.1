Return-Path: <linux-kernel-owner+w=401wt.eu-S1423222AbXDYGWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423222AbXDYGWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423227AbXDYGWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:22:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423222AbXDYGWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:22:48 -0400
Message-ID: <462EF3B0.7010700@zytor.com>
Date: Tue, 24 Apr 2007 23:22:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M
 group to 1000M group
References: <15F501D1A78BD343BE8F4D8DB854566B130752BE@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B130752BE@hkemmail01.nvidia.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> nForce ehternet is a Gigabit NIC not 100M, move it to 1000M group to
> avoid the confusion.

Overall, maybe the 100 Mbps vs 1000 Mbps distinction is getting less
useful and it would be better to have a single list.  There are a *lot*
of chipsets on the market now which have the same core and the only
difference is that one has a 100M PHY and the other has a 1000M PHY.
For example, there are 100M versions of sky2 and r8169.

	-hpa
