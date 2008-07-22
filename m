Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYGVLX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYGVLX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYGVLXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:23:20 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:18581 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYGVLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:23:20 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-28.messagelabs.com!1216725798!21284454!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 22 Jul 2008 13:23:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: sasa sasa <sasak.1983@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IRQ : bug fix in setup_irq
Message-ID: <20080722112315.GA28060@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aecf5e530807220142k4d53aa7aq568385cfc6cd44a0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Jul 2008 11:23:15.0600 (UTC) FILETIME=[559A2100:01C8EBED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sandeep,

there is a patch in -mm that does the same (and more, so it asserts that
irqaction *new isn't added to the desc->action list if set_type fails.)

See http://thread.gmane.org/gmane.linux.kernel/698011/focus=702236 or 

	handle-failure-of-irqchip-set_type-in-setup_irq.patch
	handle-failure-of-irqchip-set_type-in-setup_irq-update.patch

in mmotm.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
