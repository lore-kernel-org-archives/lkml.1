Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbZGCXk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbZGCXk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 19:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZGCXkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 19:40:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZGCXkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 19:40:20 -0400
Date: Sat, 4 Jul 2009 01:40:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090703234023.GM2041@one.firstfloor.org>
References: <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy> <20090629210206.GB13125@elte.hu> <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy> <87bpo1aaaf.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907031719530.17372@pianoman.cluster.toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907031719530.17372@pianoman.cluster.toy>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 05:25:32PM -0400, Vince Weaver wrote:
> >Vince Weaver <vince@deater.net> writes:
> >>
> >>as I said in a previous post, on most x86 chips the instructions_retired
> >>counter also includes any hardware interrupts that occur during the
> >>process runtime.
> >
> >On the other hand afaik near all chips have interrupt performance counter
> >events.
> 
> I guess by "near all" you mean "only AMD"?  The AMD event also has some 

Intel CPUs typically have HW_INT.RX event.  AMD has a similar event.

> well, it's basically at least HZ extra instructions per however many 
> seconds your benchmark runs, and unfortunately it's non-deterministic 
> because it depends on keyboard/network/usb/etc interrupts too that may by 
> chance happen while your program is running.
> 
> For me, it's the determinism that matters.  Not overhead, not runtime not 

To be honest I don't think you'll ever be full deterministic. Modern
computers and operating systems are just too complex with too
many (often unpredictable) things going on in the background.  In my own
experience even simulators (which are much more stable than
real hardware) are not fully deterministic. You'll always run
into problems.

If you need 100% deterministic use a simple micro controller.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
