Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZFUV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZFUV3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZFUV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:29:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37099
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbZFUV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:29:26 -0400
Date: Sun, 21 Jun 2009 14:29:30 -0700 (PDT)
Message-Id: <20090621.142930.251405926.davem@davemloft.net>
To: simon@fire.lp0.eu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH] r8169: add phy_reset parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A3E7FC5.6060400@simon.arlott.org.uk>
References: <4A3E7FC5.6060400@simon.arlott.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>
Date: Sun, 21 Jun 2009 19:45:25 +0100

> When booting over the network the physical link will already be up
> and configured appropriately, so there is no need to reset it and
> cause auto-negotiation to occur again. Adding an option to disable
> this makes it possible to avoid a 2 second delay while booting.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

This is getting out of control.

We're not going to add a hundred different obscure module options to
eliminate delays and device resets.
