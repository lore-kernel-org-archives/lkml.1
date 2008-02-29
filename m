Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYB2U0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYB2U0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYB2U0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:26:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38727
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYB2U03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:26:29 -0500
Date: Fri, 29 Feb 2008 12:26:29 -0800 (PST)
Message-Id: <20080229.122629.97399970.davem@davemloft.net>
To: Kim.Heino@bluegiga.com
Cc: maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix RTNL-locking in tun/tap driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <47C52F8D.7020301@bluegiga.com>
References: <47C52F8D.7020301@bluegiga.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
Date: Wed, 27 Feb 2008 11:38:21 +0200

> Current tun/tap driver sets also net device's hw address when asked to
> change character device's hw address. This is a good idea, but it
> misses RTLN-locking, resulting following error message in
> 2.6.25-rc3's inetdev_event() function:
> 
> RTNL: assertion failed at net/ipv4/devinet.c (1050)
> 
> Attached patch fixes this problem.
> 
> Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>

Applied, thanks.
