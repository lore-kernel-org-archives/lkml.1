Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab0BHDkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:40:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51000
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757754Ab0BHDkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:40:13 -0500
Date: Sun, 07 Feb 2010 19:40:22 -0800 (PST)
Message-Id: <20100207.194022.53074897.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sri@us.ibm.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100208132243.ab967d9c.sfr@canb.auug.org.au>
References: <20100208132243.ab967d9c.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Feb 2010 13:22:43 +1100

> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
 ...
> Caused by commit bfd5f4a3d605e0f6054df0b59fe0907ff7e696d3 ("packet: Add
> GSO/csum offload support").  This build has CONFIG_PACKET_MMAP unset.
> 
> I used the version of the net tree from next-20100205 for today.

Known problem, I'm fixing it by killing the config option,
everyone should have that thing enabled by now.
