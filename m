Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZHWDdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZHWDdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 23:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933447AbZHWDdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 23:33:05 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43246 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933442AbZHWDdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 23:33:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19088.47213.327897.703458@cargo.ozlabs.ibm.com>
Date: Sun, 23 Aug 2009 13:33:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090822153346.GA3313@elte.hu>
References: <20090814134811.013873340@de.ibm.com>
	<tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
	<20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > I overlooked a case in the powerpc version of read_persistent_lock.
> > New patch:
> 
> the patches are already committed and this patch doesnt apply - mind 
> sending a delta fix against tip:master:

Is that going to leave us with a bisection breakage on powerpc once
this stuff goes upstream?  If so please fold the fix into the original
patch.

Thanks,
Paul.
