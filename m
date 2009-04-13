Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZDMTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZDMTlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZDMTlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:41:03 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:50611 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZDMTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:41:01 -0400
Date: Mon, 13 Apr 2009 21:33:11 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Peter Horton <zero@colonel-panic.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: [PATCH] mtd: fix timeout in M25P80 driver
Message-ID: <20090413193311.GA16597@deprecation.cyrius.com>
References: <20090413142633.GA1560@sloth.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413142633.GA1560@sloth.localnet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Horton <zero@colonel-panic.org> [2009-04-13 15:26]:
> Extend erase timeout in M25P80 SPI Flash driver.
> 
> The M25P80 drivers fails erasing sectors on a M25P128 because the ready
> wait timeout is too short. Change the timeout from a simple loop count to a
> suitable number of seconds.
> 
> Signed-off-by: Peter Horton <zero@colonel-panic.org>

Tested-by: Martin Michlmayr <tbm@cyrius.com>

This solves the problem I've seen on the QNAP TS-219.

-- 
Martin Michlmayr
http://www.cyrius.com/
