Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZFPJUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZFPJUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZFPJTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:19:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40469
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879AbZFPJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:19:52 -0400
Date: Tue, 16 Jun 2009 02:19:55 -0700 (PDT)
Message-Id: <20090616.021955.243374916.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090616091538.GA4184@elte.hu>
References: <20090615.050449.144947903.davem@davemloft.net>
	<20090616091538.GA4184@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Jun 2009 11:15:38 +0200

>  [<ffffffff810489e6>] __might_sleep+0xf6/0x120
>  [<ffffffff81b3921d>] lock_sock_nested+0x3d/0x120
>  [<ffffffff81c1a7d2>] x25_destroy_socket+0x22/0x180
>  [<ffffffff81c1aa4e>] x25_destroy_timer+0xe/0x10
>  [<ffffffff81060619>] run_timer_softirq+0x1d9/0x2e0
>  [<ffffffff81060560>] ? run_timer_softirq+0x120/0x2e0

What on your system is openning x25 sockets?  Some stress/torture
program that opens random sockets?

Or have you gotten into packet radio recently? :-)
