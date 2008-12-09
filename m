Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYLIIUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYLIIUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYLIIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:20:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45491
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbYLIIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:20:07 -0500
Date: Tue, 09 Dec 2008 00:20:07 -0800 (PST)
Message-Id: <20081209.002007.203471603.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: rjw@sisk.pl, mchan@broadcom.com, netdev@vger.kernel.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net (tg3): Fix failure to enable WoL by default when
 possible (rev. 2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081208190403.GA27341@xw6200.broadcom.net>
References: <200812081250.59095.rjw@sisk.pl>
	<200812081252.55715.rjw@sisk.pl>
	<20081208190403.GA27341@xw6200.broadcom.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Mon, 8 Dec 2008 11:04:03 -0800

> This has mostly been fixed up already in Dave Miller's tree.  In that
> tree, the WOL capability advertisements happens at the end of the
> tg3_get_eeprom_hw_cfg() function.
> 
> Your patch did uncover a bug though.  The removal of device_may_wakeup()
> in the first hunk of your patch still needs to be done.

Ok, can someone post a patch that takes care of that against
net-next-2.6?

Thanks in advance!
