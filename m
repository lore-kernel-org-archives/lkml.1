Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYJTRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYJTRxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYJTRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:53:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJTRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:53:14 -0400
Date: Mon, 20 Oct 2008 13:53:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
In-Reply-To: <c62985530810201042v4b3eed0ah62de285c64b2c0ba@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810201351130.5336@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org>  <20080906120346.GA30964@elte.hu>  <20081016181452.GA29739@yoda.jdub.homelinux.org>  <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>  <20081016183529.GB29739@yoda.jdub.homelinux.org> 
 <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>  <20081016150106.6ddf7e46@zod.rchland.ibm.com>  <alpine.DEB.1.10.0810201222570.3760@gandalf.stny.rr.com>  <20081020170808.GB7249@yoda.jdub.homelinux.org>
 <c62985530810201042v4b3eed0ah62de285c64b2c0ba@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Oct 2008, Fr?d?ric Weisbecker wrote:

> There are other arch that support ftrace as well like sh or sparc64
> (I'm currently working on
> an implementation for mips).
> So the choice would be better between waiting for a fix or disable
> dynamic ftrace
> on Kconfig only for PowerPC.

Hi Frederic,

I believe MIPS has the same issues as PPC. Doesn't it use a trampoline 
too?  I want to make the generic code handle trampolines a bit better. 
This is one of the problems with developing in x86. It avoids a lot of the 
issues that other archs might have.

-- Steve

