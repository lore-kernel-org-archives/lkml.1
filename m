Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbYBABHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbYBABHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYBABHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:07:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYBABHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:07:18 -0500
Date: Thu, 31 Jan 2008 17:07:39 -0800 (PST)
Message-Id: <20080131.170739.246050174.davem@davemloft.net>
To: mchan@broadcom.com
Cc: 12o3l@tiscali.nl, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [drivers/net/bnx2.c] ADVERTISE_1000XPSE_ASYM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1201719070.7190.4.camel@dell>
References: <47A084B0.1000301@tiscali.nl>
	<1201719070.7190.4.camel@dell>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Wed, 30 Jan 2008 10:51:10 -0800

> [BNX2]: Fix ASYM PAUSE advertisement for remote PHY.
> 
> We were checking for the ASYM_PAUSE bit for 1000Base-X twice instead
> checking for both the 1000Base-X bit and the 10/100/1000Base-T bit.
> The purpose of the logic is to tell the firmware that ASYM_PAUSE is
> set on either the Serdes or Copper interface.
> 
> Problem was discovered by Roel Kluin <12o3l@tiscali.nl>
> 
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Applied, thanks Michael.
