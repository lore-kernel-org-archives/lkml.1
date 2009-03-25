Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZCYOcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZCYOcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZCYObu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:31:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51076 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCYObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:31:49 -0400
From: Subrata Modak <tosubrata@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Sachin Sant <sachinp@in.ibm.com>, Subrata Modak <tosubrata@gmail.com>,
       netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       Adam Nielsen <a.nielsen@shikadi.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Mar 2009 20:01:42 +0530
Message-Id: <20090325143142.6171.24387.sendpatchset@subratamodak.linux.ibm.com>
Subject: Re: [PATCH] Re: Next March 25: net/netfilter/xt_LED build failure.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick,

>Does this patch fix it?

Sorry, yes it does for make. But i was executing:

make net/netfilter/xt_LED.o

>
><diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>index 2562d05..2c967e4 100644
>--- a/net/netfilter/Kconfig
>+++ b/net/netfilter/Kconfig
>@@ -374,7 +374,7 @@ config NETFILTER_XT_TARGET_HL
>
> config NETFILTER_XT_TARGET_LED
>       tristate '"LED" target support'
>-       depends on LEDS_CLASS
>+       depends on LEDS_CLASS && LED_TRIGGERS
>       depends on NETFILTER_ADVANCED
>       help
>         This option adds a `LED' target, which allows you to blink LEDs in

Thanks.

Regards--
Subrata
