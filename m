Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZD2MJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZD2MJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZD2MJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:09:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64673 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbZD2MJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:09:05 -0400
Date: Wed, 29 Apr 2009 08:09:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Sachin Sant <sachinp@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next April 24: [S390] allmodconfig build failure
 (trace/events)
In-Reply-To: <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.0904290808300.8066@gandalf.stny.rr.com>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F16654.8040208@in.ibm.com> <20090424072533.GE24912@elte.hu> <20090424104108.0f2c0f05@osiris.boeblingen.de.ibm.com> <49F8232B.4090007@in.ibm.com>
 <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Apr 2009, Heiko Carstens wrote:
> 
> Subject: [PATCH] tracing: fix compile error
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> "tracing: create automated trace defines" causes this compile error on s390:
> 
> kernel/built-in.o: In function `__do_softirq':
> (.text+0x1c680): undefined reference to `__tracepoint_softirq_entry'
> 
> This happens because the definitions of the softirq tracepoints were moved
> from kernel/softirq.c to kernel/irq/handle.c. Since s390 doesn't support
> generic hardirqs handle.c doesn't get compiled and the definitions are
> missing.
> So move the tracepoints to softirq.c again.

Nice catch!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
