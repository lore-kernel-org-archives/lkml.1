Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbYFFSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbYFFSbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYFFSbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:31:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYFFSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:31:10 -0400
Date: Fri, 6 Jun 2008 20:40:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Denys Fedoryshchenko <denys@visp.net.lb>,
       linux-kernel@vger.kernel.org
Subject: Re: strange timestamp in dmesg
Message-ID: <20080606184048.GB13101@one.firstfloor.org>
References: <20080605115256.M13181@visp.net.lb> <20080606031939.285679c9.akpm@linux-foundation.org> <87hcc6u109.fsf@basil.nowhere.org> <20080606112547.13b78888.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606112547.13b78888.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:25:47AM -0700, Andrew Morton wrote:
> We've seen a storm of hey-my-timestamps-went-weird reports in just the
> past month or so.  I don't recall it being (such) a problem before that.
> 
> Did we change something

Nominally not, but who really knows with 5 digit number worth of changesets?

At least 64bit should have been always like this, but you only
see it on specific circumstances.

> > I always advocated just always using jiffies for printk. The only drawback would
> > be that it won't increase in interrupt off sections, but if you have
> > one that is longer than a jiffie then you have enough other problems.
> 
> I forget why, but we _were_ going to have an (arch-overrideable)
> printk_clock() function.  And we still could.  The x86 implementation
> of that could fall back to jiffies if the TSCs are out of whack?

The rewritten sched_clock I used to plug, but which yielded about
zero interest, had one.

-Andi

