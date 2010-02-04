Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab0BDXkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:40:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47139
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933112Ab0BDXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:40:19 -0500
Date: Thu, 04 Feb 2010 15:40:31 -0800 (PST)
Message-Id: <20100204.154031.124668996.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.33 4/4] net: Add PCI vendor and device ids for
 Micrel KSZ8841/2 PCI devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A55@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A55@MORGANITE.micrel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Thu, 4 Feb 2010 15:28:29 -0800

> From: Tristram Ha <Tristram.Ha@micrel.com>
> 
> Add PCI vendor and device ids for Micrel KSZ8841/2 PCI devices.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>

We no longer add device ID defines to the linux/pci_ids.h
file, in fact it's been this way for several years.

Just use constants or local devices in your driver.

Furthermore, because you made this the last patch, the
tree would fail to build at the point where the first
three of your patches are applied.

This breaks GIT bisection, and is severely frowned upon.  The tree
must build with all available kernel config options enabled at every
step of applying your set of patches.
