Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYJNHIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYJNHIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYJNHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:08:16 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:51038 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYJNHIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:08:16 -0400
Subject: Re: [PATCH] serial: remove unused variable
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Jianjun Kong <kongjianjun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081014055047.GA6552@ubuntu>
References: <1223938711.21717.16.camel@odie.local>
	 <20081014055047.GA6552@ubuntu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 14 Oct 2008 09:08:44 +0200
Message-Id: <1223968124.4282.4.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tir, 14 10 2008 kl. 13:50 +0800, skrev Jianjun Kong:
> On Tue, Oct 14, 2008 at 12:58:31AM +0200, Simon Holm Th�gersen wrote:
> >This fixes the following compile warning:
> >
> >drivers/serial/8250.c: In function 'serial8250_init':
> >drivers/serial/8250.c:2963: warning: unused variable 'i'
> >
> >that was introduced by b70ac771 (serial: allow 8250 to be used on sparc)
> >that removed the last use of the variable.
> >
> >Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
> >---
> > drivers/serial/8250.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> >index d4104a3..625fc20 100644
> >--- a/drivers/serial/8250.c
> >+++ b/drivers/serial/8250.c
> >@@ -2960,7 +2960,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
> > 
> > static int __init serial8250_init(void)
> > {
> >-	int ret, i;
> >+	int ret;
> > 
> > 	if (nr_uarts > UART_NR)
> > 		nr_uarts = UART_NR;
> 
> I find those code in this function  __init serial8250_init(void)
> 
>         for (i = 0; i < NR_IRQS; i++)
>                 spin_lock_init(&irq_lists[i].lock);
> 
> So you do not remove the 'i'.
> 
Look at the referenced commit b70ac771 (serial: allow 8250 to be used on
sparc). It is quite recent (Mon Oct 13 10:36:31 2008 +0100), but if you
pull Linus' latest tree it is there.


Simon

