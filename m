Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXEGUhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXEGUhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966721AbXEGUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:37:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46958 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716AbXEGUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:37:29 -0400
Date: Mon, 7 May 2007 13:40:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] Fix Linuxdoc comment
Message-Id: <20070507134020.26a6be17.randy.dunlap@oracle.com>
In-Reply-To: <20070507202019.GA8512@c2.user-mode-linux.org>
References: <20070507202019.GA8512@c2.user-mode-linux.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 16:20:19 -0400 Jeff Dike wrote:

> A linuxdoc comment had fallen out of date - it refers to an argument
> which no longer exists.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  kernel/irq/handle.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6.21-mm/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.21-mm.orig/kernel/irq/handle.c	2007-05-02 11:21:45.000000000 -0400
> +++ linux-2.6.21-mm/kernel/irq/handle.c	2007-05-04 14:53:58.000000000 -0400
> @@ -22,7 +22,6 @@
>   * handle_bad_irq - handle spurious and unhandled irqs
>   * @irq:       the interrupt number
>   * @desc:      description of the interrupt
> - * @regs:      pointer to a register structure
>   *
>   * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
>   */

Yes, I (or someone) need(s) to make scripts/kernel-doc catch "extra"
function @parameters like that.

BTW, this patch shouldn't be part of the UML patch series...
it's totally unrelated.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
