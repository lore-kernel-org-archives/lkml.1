Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbXHISUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbXHISUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbXHISTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:19:49 -0400
Received: from www.osadl.org ([213.239.205.134]:60607 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754729AbXHISTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:19:49 -0400
From: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Andy Herzig <andrew.herzig@ngc.com>
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Thu, 9 Aug 2007 20:19:46 +0200
User-Agent: KMail/1.9.5
Cc: Marc Pignat <marc.pignat@hevs.ch>, linux-arm-kernel@lists.arm.linux.org.uk,
       andrew@sanpeople.com, trivial@kernel.org, linux-kernel@vger.kernel.org
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com> <200708091801.20077.marc.pignat@hevs.ch> <1186679874.17413.12.camel@leoh9-18574.nges.northgrum.com>
In-Reply-To: <1186679874.17413.12.camel@leoh9-18574.nges.northgrum.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092019.46167.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 09 August 2007 19:17 schrieb Andy Herzig:
> On Thu, 2007-08-09 at 18:01 +0200, Marc Pignat wrote:
> 
> > > > +#if defined(CONFIG_ARCH_AT91RM9200)
> > > >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > > > self-refresh mode */
> > Why don't use:
> > if (cpu_is_at91rm9200())
> > 	at91_sys_write(AT91_SDRAMC_SRR, 1);
> > 
> No reason. That looks good to me.

No, it doesn't look good. It won't compile.

Hans

