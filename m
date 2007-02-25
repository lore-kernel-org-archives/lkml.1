Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXBYA5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXBYA5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932924AbXBYA5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:57:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57209
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932908AbXBYA5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:57:11 -0500
Date: Sat, 24 Feb 2007 16:57:10 -0800 (PST)
Message-Id: <20070224.165710.112620232.davem@davemloft.net>
To: xmxwx@asn.pl
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv6 anycast refcnt fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <erqkc9$9sb$1@sea.gmane.org>
References: <erqkc9$9sb$1@sea.gmane.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Wrobel <xmxwx@asn.pl>
Date: Sun, 25 Feb 2007 01:13:59 +0100

> This patch fixes a bug in Linux IPv6 stack which caused anycast address 
> to be added to a device prior DAD has been completed. This led to 
> incorrect reference count which resulted in infinite wait for 
> unregister_netdevice completion on interface removal.
> 
> Signed-off-by: Michal Wrobel <xmxwx@asn.pl>

Please post networking patches to the networking mailing list,
netdev@vger.kernel.org, because most of the networking
developers do not read linux-kernel

Thank you.
