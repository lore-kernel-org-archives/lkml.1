Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbXI0OkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbXI0OkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXI0OkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:40:11 -0400
Received: from mx12.go2.pl ([193.17.41.142]:50838 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755922AbXI0OkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:40:09 -0400
Date: Thu, 27 Sep 2007 16:42:28 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger\. Kernel\. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927144228.GC2431@ff.dom.local>
References: <20070926133138.GA23187@elte.hu> <20070927093002.GA2431@ff.dom.local> <20070927094603.GA32469@elte.hu> <20070927122746.GB2431@ff.dom.local> <20070927133123.GA6901@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927133123.GA6901@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 03:31:23PM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
...
> > OK, but let's forget about fixing iperf. Probably I got this wrong, 
> > but I've thought this "bad" iperf patch was tested on a few nixes and 
> > linux was the most different one. The main point is: even if there is 
> > no standard here, it should be a common interest to try to not differ 
> > too much at least. So, it's not about exactness, but 50% (63 -> 95) 
> > change in linux own 'definition' after upgrading seems to be a lot. 
> > So, IMHO, maybe some 'compatibility' test could be prepared to compare 
> > a few different ideas on this yield and some average value could be a 
> > kind of at least linux' own standard, which should be emulated within 
> > some limits by next kernels?
> 
> you repeat your point of "emulating yield", and i can only repeat my 
> point that you should please read this:
> 
>     http://lkml.org/lkml/2007/9/19/357
> 
> because, once you read that, i think you'll agree with me that what you 
> say is simply not possible in a sane way at this stage. We went through 
> a number of yield implementations already and each will change behavior 
> for _some_ category of apps. So right now we offer two implementations, 
> and the default was chosen empirically to minimize the amount of 
> complaints. (but it's not possible to eliminate them altogether, for the 
> reasons outlined above - hence the switch.)

Sorry, but I think you got me wrong: I didn't mean emulation of any
implementation, but probably the some thing you write above: emulation
of time/performance. In my opinion this should be done experimentally
too, but with something more objective and constant than current
"complaints counter". And the first thing could be a try to set some
kind of linux internal "standard of yeld" for the future by averaging
a few most popular systems in a test doing things like this iperf or
preferably more.

Jarek P.
