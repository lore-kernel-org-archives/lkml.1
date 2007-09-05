Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbXIEVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbXIEVBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXIEVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:01:10 -0400
Received: from panic.printk.net ([217.147.83.20]:46688 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbXIEVBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:01:09 -0400
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Neil Horman <nhorman@tuxdriver.com>, Patrick McHardy <kaber@trash.net>,
       adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
       Jim Radford <radford@blackbean.org>
In-Reply-To: <1189025486.10802.206.camel@localhost.localdomain>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
	 <20070905192744.GB25050@hmsreliant.think-freely.org>
	 <1189025486.10802.206.camel@localhost.localdomain>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Sep 2007 16:59:06 -0400
Message-Id: <1189025946.12261.151.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 06:51 +1000, Rusty Russell wrote:
> On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:
> > On Thu, Sep 06, 2007 at 03:41:37AM +1000, Rusty Russell wrote:
> > > 	You have this backwards: O_NONBLOCK is the default.  That seems to be
> > > what everyone wants, although I implemented 'rmmod -w' because it seemed
> > > like a good option.
> > > 
> > Thats really the point I'm trying to make.  O_NONBLOCK should be the default,
> > but it isn't in the case of modprobe.
> 
> Ouch, you're right!

I've applied, tagged, and updated
http://www.kernel.org/pub/linux/kernel/people/jcm/module-init-tools/devel/module-init-tools.git

I also moved the remaining files over from kerneltools.org. Will update
tarballs later...FWIW, there are a couple of outstanding patches to
libify module-init-tools that I'm still looking at before pushing.

Jon.


