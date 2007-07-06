Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbXGFMpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbXGFMpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbXGFMpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:45:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38614 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168AbXGFMpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:45:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 08:42:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead(?) i386-related CONFIG variables
In-Reply-To: <468E3579.1020109@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0707060840510.23413@localhost.localdomain>
References: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
 <468E3579.1020109@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Stefan Richter wrote:

> On 7/5/2007 1:27 PM, Robert P. J. Day wrote:
> >   since it's not clear who a single contact person would be for
> > i386-related stuff like this, here's what my script turned up for
> > tests on non-existent CONFIG variables under arch/i386:
> >
> > ========== BALANCED_IRQ_DEBUG ==========
> > arch/i386/kernel/io_apic.c:356:#ifdef CONFIG_BALANCED_IRQ_DEBUG
>
> -#ifdef CONFIG_BALANCED_IRQ_DEBUG
> +#if 0 /* debug IRQ balancing */
>
> > ========== DEBUG_PAGE_TYPE ==========
> > arch/i386/kernel/vmi.c:238:#ifdef CONFIG_DEBUG_PAGE_TYPE
>
> -#ifdef CONFIG_DEBUG_PAGE_TYPE
> +#if 0 /* debug page type */
>
> arch/i386/kernel/vmi.c:339
>
> -#endif
> +#endif /* debug page type */
>
> > ========== SERIAL_DETECT_IRQ ==========
> > arch/i386/kernel/legacy_serial.c:18:#ifdef CONFIG_SERIAL_DETECT_IRQ
>
> Hmm, not sure about this.  The code section was taken from
> include/asm-{i386,x86_64}/serial.h.  This is an option similar to other
> CONFIG_SERIAL_ options in numerous places.
>
> Serial drivers are orphaned, aren't they?

i can submit patches for the first two (i'll keep them separate since
they don't appear to be related enough to make a single patch out of
them).  and i'll wait to hear about that last one.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
