Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbYGQXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbYGQXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYGQXLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:11:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26001 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYGQXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:11:11 -0400
Date: Thu, 17 Jul 2008 16:09:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc Zyngier <maz@misterjones.org>, green@crimea.edu, wim@iguana.be,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Compile fix for sa1100_wdt
Message-Id: <20080717160956.881495e0.randy.dunlap@oracle.com>
In-Reply-To: <20080717160438.d707826b.akpm@linux-foundation.org>
References: <487C664A.2020606@misterjones.org>
	<20080717160438.d707826b.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:04:38 -0700 Andrew Morton wrote:

> On Tue, 15 Jul 2008 10:56:42 +0200
> Marc Zyngier <maz@misterjones.org> wrote:
> 
> > --- a/drivers/watchdog/sa1100_wdt.c
> > +++ b/drivers/watchdog/sa1100_wdt.c
> > @@ -29,6 +29,7 @@
> > 
> >   #ifdef CONFIG_ARCH_PXA
> >   #include <asm/arch/pxa-regs.h>
> > +#include <asm/arch/pxa2xx-regs.h>
> 
> Your email client is performing space-stuffing.
> 
> http://mbligh.org/linuxdocs/Email/Clients/Thunderbird used to have the
> repair instructions, but that server has been down for a while.
> 
> http://web.archive.org/web/20070528114159/http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
> 
> has a copy.
> --

or see if Documentation/email-clients.txt has any useful info for you...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
