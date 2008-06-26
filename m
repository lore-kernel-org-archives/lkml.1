Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYFZFz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYFZFz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYFZFzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:55:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbYFZFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:55:50 -0400
Date: Wed, 25 Jun 2008 22:55:50 -0700 (PDT)
Message-Id: <20080625.225550.199765051.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: Jie.Yang@Atheros.com, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080625224829.3c6f4789@extreme>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com>
	<20080625224829.3c6f4789@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 25 Jun 2008 22:48:29 -0700

> I would prefer that the driver be NAPI only, because configuration
> choices are hard for users and distribution to make correct
> choice. Plus it means two choices for your QA to test.

I agree with Stephen.

It's absolutely to provide a non-NAPI option, please just remove
the option and the conditionals from the code.
