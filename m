Return-Path: <linux-kernel-owner+w=401wt.eu-S965279AbXBQO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbXBQO46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 09:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXBQO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 09:56:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965279AbXBQO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 09:56:58 -0500
Date: Sat, 17 Feb 2007 15:56:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Muizelaar <jeff@infidigm.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
Message-ID: <20070217145655.GA15662@one.firstfloor.org>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <p73fy95g99w.fsf@bingen.suse.de> <20070216212630.GC27135@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216212630.GC27135@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is one of the reasons why we don't just use good old
> do_gettimeofday(), since it takes locks and can lead to lock recursion
> if parts of itself are probed.

do_gettimeofday doesn't take locks.

Only restriction is that you can't single step it with long 
pauses between instructions.

-Andi
