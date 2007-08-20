Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXHTRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXHTRO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXHTROR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:14:17 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57347 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685AbXHTROQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:14:16 -0400
Message-ID: <46C9CBDE.6030903@s5r6.in-berlin.de>
Date: Mon, 20 Aug 2007 19:14:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Xu Yang <risingsunxy@googlemail.com>
CC: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: warning in set_irq_chip, ARM port (was Re: bug information)
References: <ab40e9c0708170911r539f4f63t3659084d52567522@mail.gmail.com>	 <46C6BF3B.2000502@s5r6.in-berlin.de> <ab40e9c0708200625m2a5abd59wd91966c2c82ce12a@mail.gmail.com>
In-Reply-To: <ab40e9c0708200625m2a5abd59wd91966c2c82ce12a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xu Yang wrote:
> as long as the program jump to the interrupt
> routine(realview_timer_interrupt) of the timer0, the program can not
> go further, it only toggles between the gic_* functions, such as
> gic_ack_irq. gic_mask_irq, handle_level_irq, and so on.
> 
> do you have any idea where could be the problem?

Perhaps post your changes at linux-arm-kernel as patch against mainline,
ideally 2.6.22(.y) or 2.6.23-rc.  The people there might be in a better
position to give advice.
-- 
Stefan Richter
-=====-=-=== =--- =---=
http://arcgraph.de/sr/
