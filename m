Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZCYN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZCYN0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZCYN0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:26:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40239 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbZCYN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:26:02 -0400
Date: Wed, 25 Mar 2009 14:25:25 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090325142525.2d31c522@skybase>
In-Reply-To: <49CA2FBF.9000207@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 22:21:03 +0900
Tejun Heo <tj@kernel.org> wrote:

> Martin Schwidefsky wrote:
> >> Martin's original patch should do the trick although it would be
> >> slower for static symbols.  I'll merge it and post the tree.
> > 
> > No, my original patch doesn't work. It will break modules that use
> > static per-cpu variables.
> 
> Oops.  Even with the default offset adding macros?  Heh... I think it
> would be best to wait for your fix then.

We could use HAVE_LEGACY_PER_CPU_AREA for the time being. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

