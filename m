Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbYASGFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbYASGFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYASGE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:04:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYASGE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:04:56 -0500
Date: Sat, 19 Jan 2008 07:08:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
Message-ID: <20080119060818.GA28884@one.firstfloor.org>
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com> <20080119052709.GA28467@one.firstfloor.org> <479189BF.2000403@linux.intel.com> <20080119053330.GB28467@one.firstfloor.org> <47918BFF.9010804@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47918BFF.9010804@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> syscall nr and pid at minimum then.

oprofile already supports logging the pid I believe. Otherwise
the pid filter in opreport could hardly work.

> Still doesn't work for modules either.

oprofile works fine for modules.

> 
> what it ends up doing is using an entirely different interface for 
> basically the
> same code / operation inside the kernel.

Well rather it uses an existing framework for something that fits
it well.

Also the way I proposed is very cheap and would be possible
to use in production kernels without special configs.

> The current interface code is maybe 80 lines of /proc code... and very 
> simple to
> use (unlike the oprofile interface)

The oprofile interface is per CPU (so you wouldn't need to reinvent
that to fix your locking) and if you add the syscall
logging feature to it it would apply to all profile events
e.g. you could then do things like "matching cache misses to syscalls" 

-andi

