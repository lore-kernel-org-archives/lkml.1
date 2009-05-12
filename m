Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZELLWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZELLWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZELLW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:22:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60456 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZELLW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:22:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18953.23497.373282.595641@cargo.ozlabs.ibm.com>
Date: Tue, 12 May 2009 21:21:45 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <1242112226.11251.315.camel@twins>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
	<200905120158.46314.arnd@arndb.de>
	<1242108700.11251.304.camel@twins>
	<18953.5533.398597.677737@drongo.ozlabs.ibm.com>
	<1242109650.11251.313.camel@twins>
	<1242112226.11251.315.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ah, so _IO() gets an unsigned long 3rd argument.
> _IOW() treats the 3rd arg as a (type __user *) and copies the bits over
> _IOR() copies the bits back out to userspace
> _IORW() does both

Yep.

> In which case the below should fix things up, no?

Looks good.

Paul.
