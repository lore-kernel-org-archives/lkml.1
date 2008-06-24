Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYFXBcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYFXBcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYFXBb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:31:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYFXBb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:31:58 -0400
Date: Mon, 23 Jun 2008 18:31:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
In-Reply-To: <20080624005053.GA4827@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0806231827330.2926@woody.linux-foundation.org>
References: <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com>
 <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com> <20080616034659.GA7600@martell.zuzino.mipt.ru> <20080617034228.GA18217@linux.vnet.ibm.com>
 <20080624005053.GA4827@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Alexey Dobriyan wrote:
> 
> Status update:
> * bug is reproduced on another box with the very same symptoms:
>   SMP=y, maxcpus=1 kernel occasionally fails, SMP=n is fine.
>   Also Core 2 Duo, x86_64 [1]
> 
>   Race is wide -- 60 seconds of rcutorture is enough.

Very odd how you can reproduce it - now on two machines - but it doesn't 
seem to happen for others. You've tried different compilers, you've tried 
different config options, what the heck is left?

And it's not like Core 2 Duo is an "odd" setup. Even any timer differences 
should have been largely flushed out with HIGH_RES_TIMERS=y/n.

Is there *anything* odd about those machines?

		Linus
