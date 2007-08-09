Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbXHIWuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbXHIWuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXHIWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:50:20 -0400
Received: from imsc1.euromail.se ([217.174.79.93]:35365 "HELO
	garland.euromail.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753805AbXHIWuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:50:18 -0400
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 18:50:18 EDT
Message-ID: <018a01c7dad3$10ca8190$dcc4af0a@atmel.com>
From: "Ulf Samuelsson" <ulf@atmel.com>
To: "Marc Pignat" <marc.pignat@hevs.ch>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: <andrew@sanpeople.com>, <trivial@kernel.org>,
       <linux-kernel@vger.kernel.org>, "Andy Herzig" <andrew.herzig@ngc.com>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com><200708091653.35226.hjk@linutronix.de> <200708091801.20077.marc.pignat@hevs.ch>
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Fri, 10 Aug 2007 00:15:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-OriginalArrivalTime: 09 Aug 2007 22:19:03.0934 (UTC) FILETIME=[4B4869E0:01C7DAD3]
X-NAI-Spam-Score: 0
X-NAI-Spam-Report: 1 Rules triggered
	*  0 -- HAS_X_HELO -- Mail contains HAS_X-HELO header
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > +#if defined(CONFIG_ARCH_AT91RM9200)
> >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > self-refresh mode */

> Why don't use:
> if (cpu_is_at91rm9200())
> at91_sys_write(AT91_SDRAMC_SRR, 1);

What is the benefit?
Will the optimizer remove the code if the CPU is not the at91rm9200?

Best Regards
Ulf Samuelsson
