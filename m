Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYFOXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYFOXjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYFOXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:39:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbYFOXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:39:12 -0400
Date: Sun, 15 Jun 2008 16:38:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
In-Reply-To: <20080615232754.GD17915@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org>
References: <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi> <20080614144200.GA26421@linux.vnet.ibm.com> <20080614145839.GA10523@tv-sign.ru> <20080614181212.GB26421@linux.vnet.ibm.com> <20080614194338.GA4820@martell.zuzino.mipt.ru>
 <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Jun 2008, Paul E. McKenney wrote:
>
> If that is the right thing to do.  I would feel better about it if I
> could reproduce the failure.

Is there some configuration thing that might make it happen for Alexey but 
not for you? The only obvious one is the normal PREEMPT thing, but 
PREEMPT_RCU obviously depends on that, so there must be something else.

CONFIG_SMP? CONFIG_NO_HZ? CONFIG_[RT|FAIR]_GROUP_SCHED? There's a number 
of config options that change scheduling details..

		Linus
