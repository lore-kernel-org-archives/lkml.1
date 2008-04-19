Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYDSQVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYDSQVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYDSQVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:21:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYDSQVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:21:43 -0400
Date: Sat, 19 Apr 2008 12:16:34 -0400
From: Alan Cox <alan@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: alan@redhat.com, R.E.Wolff@BitWizard.nl,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
Message-ID: <20080419161634.GA16424@devserv.devel.redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:22:51PM -0400, Jeff Garzik wrote:
> +++ b/drivers/char/cyclades.c
>  	if (unlikely(!ISZLOADED(*cinfo))) {
>  #ifdef CY_DEBUG_INTERRUPTS
> -		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
> -				"(IRQ%d).\n", irq);
> +		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");

If you are debugging IRQ funnies you really really want to know which
IRQ or which port.

Ack the rest on the base the __foo_interrupt uglies will go away with the
final change over. A follow up patch to tweak cyclades would be useful and also
to know from Andrew if these are going in so they don't clash with the coding
style cleanups also queued.

