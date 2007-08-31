Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXHaElf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXHaElf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXHaEl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:41:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbXHaEl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:41:26 -0400
Date: Thu, 30 Aug 2007 21:41:26 -0700 (PDT)
Message-Id: <20070830.214126.95059798.davem@davemloft.net>
To: dstromberglists@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: ifconfig changing a routing table?
From: David Miller <davem@davemloft.net>
In-Reply-To: <fb83g8$nac$1@sea.gmane.org>
References: <fb83g8$nac$1@sea.gmane.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Stromberg <dstromberglists@gmail.com>
Date: Fri, 31 Aug 2007 03:55:53 +0000 (UTC)

> I'm not accustomed to ifconfig changing the routing table.  Is this 
> normal?

Every time you enable an IP address on an interface, the
kernel creates a route to that subnet which gets likewise
deleted when you remove that IP address.

This is why you can ping hosts on your local subnet even
before you add any explicit routes.

It's been like this since ancient times and it's correct.
