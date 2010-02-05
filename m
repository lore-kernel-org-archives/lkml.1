Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0BEE1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:27:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45432
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab0BEE1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:27:41 -0500
Date: Thu, 04 Feb 2010 20:27:54 -0800 (PST)
Message-Id: <20100204.202754.252960217.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.33 4/4] net: Add PCI vendor and device ids for
 Micrel KSZ8841/2 PCI devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D5CC333@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A55@MORGANITE.micrel.com>
	<20100204154004.44e3d607@nehalam>
	<14385191E87B904DBD836449AA30269D5CC333@MORGANITE.micrel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Thu, 4 Feb 2010 18:55:31 -0800

> Stephen Hemminger wrote:
>> Current practice is to NOT update this file and instead keep constants
> in the individual driver.
> 
> It seems I received conflicted recommendation from Alan Cox:

Alan's understanding is several years out of date.

Stephen's is correct.

But you don't need these stupid defines at all, all you
use them for is the PCI device ID table in your driver
so just use constants.
