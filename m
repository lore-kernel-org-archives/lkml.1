Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZGCSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZGCSbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZGCSbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:31:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbZGCSbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:31:02 -0400
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	<20090624151010.GA12799@elte.hu>
	<Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
	<Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
	<20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu>
	<Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
	<20090629210206.GB13125@elte.hu>
	<Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
Date: Fri, 03 Jul 2009 20:31:04 +0200
In-Reply-To: <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy> (Vince Weaver's message of "Thu, 2 Jul 2009 17:07:02 -0400 (EDT)")
Message-ID: <87bpo1aaaf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver <vince@deater.net> writes:
>
> as I said in a previous post, on most x86 chips the instructions_retired
> counter also includes any hardware interrupts that occur during the
> process runtime.

On the other hand afaik near all chips have interrupt performance counter
events.

So if you're willing to waste one of the variable counter registers 
you can always count those and then correct based on the other count.

But the question is of course if it's worth it, the error should 
be really small. Also you could always lose a few cycles occasionally
in other "random" events, which can happen too.

>  So any clock interrupts, etc, show up as an extra
> instruction.  So on the "million" benchmark, it's usually +/- 2 extra
> instructions.

1-2 error in a million doesn't sound like a catastrophic problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
