Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360Ab0AWVcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0AWVcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908Ab0AWVcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:32:03 -0500
Received: from ppp-157-144.adsl.restena.lu ([158.64.157.144]:42379 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0AWVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:32:01 -0500
Date: Sat, 23 Jan 2010 22:31:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
 vlan_skb_recv - probably introduced by commit
 9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100123223132.0e62d8cb@neptune.home>
In-Reply-To: <20100123165657.187c11e4@neptune.home>
References: <20100123165657.187c11e4@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Above part of code did change between 2.6.32 and 2.6.33-rc5 with
> commit 9793241fe92f7d9303fb221e43fc598eb065f267 (vlan: Precise RX
> stats accounting)
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9793241fe92f7d9303fb221e43fc598eb065f267

Reverting just that commit gets the system running correctly.

Bruno
