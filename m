Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbYLHIyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbYLHIyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYLHIyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:54:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48143
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYLHIyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:54:31 -0500
Date: Mon, 08 Dec 2008 00:54:31 -0800 (PST)
Message-Id: <20081208.005431.200957157.davem@davemloft.net>
To: mitake@clustcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [RFC] New functions to manipulate registers for ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081208171230.288c5ccf.mitake@clustcom.com>
References: <20081208171230.288c5ccf.mitake@clustcom.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@clustcom.com>
Date: Mon, 8 Dec 2008 17:12:30 +0900

> I want to add two new functions to ethtool.
> 
> One is for setting driver's registers on MMIO area like
> --change-eeprom option.

You can map the registers into userspace using the bus
level mmap facilities exported to userspace.

No ethtool support is necessary for this.

> Another function is for reading driver's register on MMIO.

Also not necessary, for the same reasons described
above.
