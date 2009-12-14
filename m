Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbZLNST4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbZLNST4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZLNST4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:19:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36414
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240AbZLNSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:19:55 -0500
Date: Mon, 14 Dec 2009 10:19:53 -0800 (PST)
Message-Id: <20091214.101953.24324389.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: lists@nerdbynature.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, john.dykstra1@gmail.com
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B267708.3010202@gmail.com>
References: <4B25D38F.1090702@gmail.com>
	<20091213.234530.82029083.davem@davemloft.net>
	<4B267708.3010202@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Dec 2009 18:34:00 +0100

> And commit 96e0bf4b5193d0d97d139f99e2dd128763d55521
> (tcp: Discard segments that ack data not yet sent)
> 
> Did change this area a bit :

Good catch.

I can reproduce this quite readily so I'll try reverting that
commit.
