Return-Path: <linux-kernel-owner+w=401wt.eu-S1765601AbYEBJJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765601AbYEBJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbYEBJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:09:44 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:50004 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbYEBJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:09:43 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Rini <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
       bunk@kernel.org, venkatesh.pallipadi@intel.com, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       vegard.nossum@gmail.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
From: Andi Kleen <andi@firstfloor.org>
References: <20080430013108.GA18207@linux-os.sc.intel.com>
	<20080429.212833.192304794.davem@davemloft.net>
	<924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
	<20080501215633.GU29330@cs181133002.pp.htv.fi>
	<20080501152051.4eb4bad3.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
	<20080501153349.f4537ec7.akpm@linux-foundation.org>
	<20080501232447.GF4354@smtp.west.cox.net>
	<20080501165945.077d34f9.akpm@linux-foundation.org>
Date: Fri, 02 May 2008 11:09:23 +0200
In-Reply-To: <20080501165945.077d34f9.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 1 May 2008 16:59:45 -0700")
Message-ID: <87skx1f4xo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 09:02:29.0071 (UTC) FILETIME=[3F9E55F0:01C8AC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Honestly, I nearly died when I built all those cross-compilers.  Sooooooo
> many combinations of gcc/binutils/glibc refused to work for obscure
> reasons.  Compilation on x86_64 just didn't work at all and I ended up
> having to build everything on a slow i386 box, etc, etc.  The stream of
> email to Dan got increasingly strident ;)

This might be pointing out the obvious, but to just update the compiler
from 4.1.0 to 4.1.2 (or other) you don't need to recompile binutils and glibc.

-Andi
