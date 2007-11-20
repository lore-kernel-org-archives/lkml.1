Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXKTKmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXKTKmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXKTKm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:42:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbXKTKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:42:28 -0500
Date: Tue, 20 Nov 2007 02:42:27 -0800 (PST)
Message-Id: <20071120.024227.121377069.davem@davemloft.net>
To: wyb@topsec.com.cn
Cc: linux-kernel@vger.kernel.org
Subject: Re: is it useful testing __LINK_STATE_RX_SCHED in dev_close()?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711201028.AYF43414@topsec.com.cn>
References: <200711201028.AYF43414@topsec.com.cn>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: <wyb@topsec.com.cn>
Date: Tue, 20 Nov 2007 18:26:26 +0800

> cpu0 calling netif_rx_schedule_prep(), cpu1 calling dev_close():
> 
> cpu0: testing __LINK_STATE_START, already set
> cpu1: clear__LINK_STATE_START
> cpu1: testing __LINK_STATE_RX_SCHED, not set
> cpu0: set __LINK_STATE_RX_SCHED
> cpu0: enter net poll, ...
> 
> when cpu1 return from dev_close(),__LINK_STATE_RX_SCHED is still set.

You'll have better luck asking networking questions on
netdev@vger.kernel.org as that is the mailing list where
the kernel networking developers are subscribed.
