Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYGaKtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYGaKtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYGaKtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:49:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54853
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYGaKtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:49:04 -0400
Date: Thu, 31 Jul 2008 03:49:04 -0700 (PDT)
Message-Id: <20080731.034904.190066778.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com,
       mpm@selenic.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080731104004.GN10471@solarflare.com>
References: <20080731092703.661994657@free-electrons.com>
	<20080731093221.236840420@free-electrons.com>
	<20080731104004.GN10471@solarflare.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 31 Jul 2008 11:40:05 +0100

> You also need to conditionalise dev_disable_lro().

That can only be done once the CONFIG_ETHTOOL select statement
is added for CONFIG_INET.

Which basically makes this CONFIG_ETHTOOL thing completely pointless.
