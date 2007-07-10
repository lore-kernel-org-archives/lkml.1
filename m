Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXGJXzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXGJXzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXGJXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:54:59 -0400
Received: from ozlabs.org ([203.10.76.45]:46218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbXGJXy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:54:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18068.5829.53635.797336@cargo.ozlabs.ibm.com>
Date: Wed, 11 Jul 2007 09:31:17 +1000
From: Paul Mackerras <paulus@samba.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Gabriel Paubert <paubert@iram.es>, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
In-Reply-To: <78777AB0-8FA2-4FB0-9D02-6504ED28957D@kernel.crashing.org>
References: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	<464C9E67.2020909@ru.mvista.com>
	<6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>
	<464CA222.8000407@ru.mvista.com>
	<464D9E7E.3090605@genesi-usa.com>
	<464DADFC.3080802@ru.mvista.com>
	<464DB800.40702@genesi-usa.com>
	<1179499713.12981.75.camel@chaos>
	<32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
	<464DD9DD.8030603@genesi-usa.com>
	<20070710105212.GA14682@iram.es>
	<78777AB0-8FA2-4FB0-9D02-6504ED28957D@kernel.crashing.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:

> > This scales with the number of processors since there is one
> > decrementer per core (is it per thread on SMT chips?
> > I don't know).
> 
> One per core.

No, each thread has its own decrementer, but the timebase is shared.

Paul.
