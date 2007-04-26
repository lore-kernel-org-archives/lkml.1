Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXDZEQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXDZEQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXDZEQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:16:32 -0400
Received: from holomorphy.com ([66.93.40.71]:43630 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbXDZEQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:16:32 -0400
Date: Wed, 25 Apr 2007 21:16:12 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070426041612.GD19966@holomorphy.com>
References: <20070425214704.GA32572@elte.hu> <20070426032923.GB1548@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426032923.GB1548@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:47:04PM +0200, Ingo Molnar wrote:
>>  - upstream fix: SysRq-T should show runnable tasks

On Thu, Apr 26, 2007 at 05:29:27AM +0200, Nick Piggin wrote:
> BTW. can you send this upstream? It is very annoying how it currently works,
> and I've had more than one bug that required seeing runnable tasks in order
> to diagnose and fix...

There are other things that should go upstream separately. The
init/main.c comment fix for one. I'd even argue that scheduler classes
should be done separately from and prior to the specific cfs policy.


-- wli
