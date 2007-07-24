Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXGXTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXGXTN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbXGXTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:13:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34463 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGXTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:13:48 -0400
Date: Tue, 24 Jul 2007 21:13:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Aaron Porter <atporter@primate.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
Message-ID: <20070724191347.GB359@one.firstfloor.org>
References: <20070724172513.GB24543@primate.net> <p73vec9sknz.fsf@bingen.suse.de> <20070724184908.GD24543@primate.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724184908.GD24543@primate.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> # opreport -l
> CPU: AMD64 processors, speed 1994.52 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
> samples  %        app name                 symbol name
> 914379   48.8404  vmlinux-2.6.21.5         check_poison_obj
> 341920   18.2632  vmlinux-2.6.21.5         poison_obj

You have slab debugging enabled. That makes everything slow.
It costs you ~66% of your CPU time.  Disable it.

-Andi

