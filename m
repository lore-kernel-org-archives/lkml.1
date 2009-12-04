Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZLDAFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZLDAFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZLDAFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:05:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50750
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbZLDAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:05:04 -0500
Date: Thu, 03 Dec 2009 16:05:11 -0800 (PST)
Message-Id: <20091203.160511.211490797.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: ben@simtec.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle
 Zippy combo board
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Thu, 3 Dec 2009 13:30:03 -0800

> From: Tristram Ha <Tristram.Ha@micrel.com>
> 
> The Micrel KSZ8851 SNL Ethernet chip is used in the OMAP Beagle Zippy combo board.  Requesting interrupt using level triggering flag hangs the system because the interrupt handling routine is called continually.  Using edge triggering avoids this problem.  As a result, disabling interrupt may not be necessary.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>

You say "may not be necessary", do you actually know for sure?

This seems questionable, if the interrupt disabling was there
for a reason what has changed to make it such that it is no
longer necessary?
