Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbYBUPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbYBUPEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYBUPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:04:10 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:54548 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYBUPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:04:09 -0500
Date: Fri, 22 Feb 2008 00:04:17 +0900 (JST)
Message-Id: <20080222.000417.126763769.anemo@mba.ocn.ne.jp>
To: hskinnemoen@atmel.com
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] macb: Fix speed setting
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080221151246.6f2044b9@dhcp-252-066.norway.atmel.com>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
	<20080221151246.6f2044b9@dhcp-252-066.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 15:12:46 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> I have to admit that even after looking through include/linux/phy.h and
> include/linux/mii.h, I don't have the faintest idea what values we can
> expect to find in the "speed" field of phydev. The comment above struct
> phy_device says that it is used "like in mii_if_info", but struct
> mii_if_info doesn't have a "speed" field...
> 
> I'm willing to take your word for it, but some documentation would be
> really nice...

Well, simple grepping drivers/net/phy
