Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYBHX3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYBHX3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYBHX3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:29:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbYBHX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:29:35 -0500
Date: Fri, 8 Feb 2008 15:28:12 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-ID: <20080208152812.2bb14374@extreme>
In-Reply-To: <20080208232536.GA15727@elte.hu>
References: <200802060108.31644.dtor@insightbb.com>
	<20080208232536.GA15727@elte.hu>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 00:25:36 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dmitry Torokhov <dtor@insightbb.com> wrote:
> 
> > Stephen Hemminger (2):
> >       Input: add driver for Fujitsu application buttons
> 
> this change broke the build on x86 in randconfig testing:
> 
>   drivers/built-in.o: In function `apanel_detach_client':
>   apanel.c:(.text+0x15c120): undefined reference to  `__led_classdev_unregister'
>   drivers/built-in.o: In function `apanel_probe':
>   apanel.c:(.text+0x15c30f): undefined reference to  `led_classdev_register'
> 
> .config attached.
> 
> the Kconfig dependencies seem incomplete:
> 
> > +config INPUT_APANEL
> > +     tristate "Fujitsu Lifebook Application Panel buttons"
> > +     depends on X86
> > +     select I2C_I801
> > +     select INPUT_POLLDEV
> > +     select CHECK_SIGNATURE
> > +     help
> 
> it doesnt list LEDS.
> 
> 	Ingo

I think someone already sent a patch to select the LEDS

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
