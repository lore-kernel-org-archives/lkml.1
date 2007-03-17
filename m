Return-Path: <linux-kernel-owner+w=401wt.eu-S965625AbXCQOiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbXCQOiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXCQOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:38:05 -0400
Received: from squawk.glines.org ([72.36.206.66]:54230 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965636AbXCQOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:38:04 -0400
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 10:38:04 EDT
Date: Sat, 17 Mar 2007 07:09:06 -0700
From: Mark Glines <mark-ck@glines.org>
To: Mike Galbraith <efault@gmx.de>
Cc: David Lang <david.lang@digitalinsight.com>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Subject: Re: [ck] Re: RSDL v0.31
Message-ID: <20070317070906.1b84318c@chirp>
In-Reply-To: <1174121187.8647.20.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	<200703170040.48316.kernel@kolivas.org>
	<1174059299.7886.25.camel@Homer.simpson.net>
	<200703170813.32594.kernel@kolivas.org>
	<1174084207.7009.9.camel@Homer.simpson.net>
	<1174105443.3144.4.camel@entropy>
	<1174110965.7911.44.camel@Homer.simpson.net>
	<1174112768.3144.8.camel@entropy>
	<20070317074506.GA13685@elte.hu>
	<Pine.LNX.4.63.0703162326020.6015@qynat.qvtvafvgr.pbz>
	<1174121187.8647.20.camel@Homer.simpson.net>
Organization: Glines.org
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.10.11; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007 09:46:27 +0100
Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2007-03-16 at 23:44 -0800, David Lang wrote:
> 
> > why isn't niceing X to -10 an acceptable option?
> 
> Xorg's priority is only part of the problem.  Every client that needs
> a substantial quantity of cpu while a hog is running will also need
> to be negative nice, no?

I don't suppose you can be a bit more specific, and define how much CPU
constitutes a "substantial quantity"?  It looks to me like X already got
about half of a CPU.

>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> 6599 root      26   0  174m  30m 8028 R   51  3.1   7:08.70 0 Xorg


I'm hoping that actually quantifying this issue will result in a better
understanding of the issue...

Thanks,

Mark
