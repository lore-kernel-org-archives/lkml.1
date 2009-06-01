Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZFAKWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZFAKWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZFAKWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:22:39 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56472 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZFAKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:22:38 -0400
Date: Mon, 1 Jun 2009 12:22:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 2/2] keep on ticking if oprofile is active
Message-ID: <20090601122234.725c1e97@skybase>
In-Reply-To: <87vdngcr48.fsf@basil.nowhere.org>
References: <20090528150447.152019714@de.ibm.com>
	<20090528150502.305840931@de.ibm.com>
	<87vdngcr48.fsf@basil.nowhere.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jun 2009 10:09:27 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Martin Schwidefsky <schwidefsky@de.ibm.com> writes:
> 
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >
> > On a NOHZ system with oprofile enabled the timer tick should not be
> 
> The old style profile=... profiler should do that too.

Technically the old style profiler and NOHZ can be combined (see patch
#1 plus a fix as discussed with Thomas). On the other hand it would make
the code simpler if we just fallback to the standard tick if profile= is
used. My personal preference would be to use my patch.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

