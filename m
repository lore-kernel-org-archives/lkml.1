Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0BCBki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:40:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47988
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184Ab0BCBkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:40:32 -0500
Date: Tue, 02 Feb 2010 17:40:45 -0800 (PST)
Message-Id: <20100202.174045.135005544.davem@davemloft.net>
To: ktpedre@sandia.gov
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265160242.15726.20.camel@hawkeye.sandia.gov>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
	<20100202.134251.15604523.davem@davemloft.net>
	<1265160242.15726.20.camel@hawkeye.sandia.gov>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kevin Pedretti" <ktpedre@sandia.gov>
Date: Tue, 2 Feb 2010 18:24:02 -0700

> 4. Device only supports IPv4? -> Yes, that's correct. No IPv6 support.
> The driver squashes everything but IPv4 in eth2ss().

Not just IPV6, what about other ethernet protocols?

What about ARP?  How does IPV4 work if you only accept ETH_P_IP?  You
need to accept at least ETH_P_ARP for things to work.

> 2. May want to use alloc_netdev() -> Didn't do this. Would there be a
> substantial advantage to doing this?

I think you're going to end up having to make this change.
