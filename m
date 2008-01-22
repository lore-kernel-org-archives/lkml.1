Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYAVFwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYAVFwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYAVFvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:51:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33847 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYAVFvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:51:53 -0500
Date: Tue, 22 Jan 2008 06:52:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lkml <linux-kernel@vger.kernel.org>,
       dipankar@in.ibm.com, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: fix section mismatch
Message-ID: <20080122055201.GA4810@uranus.ravnborg.org>
References: <20080119115643.43236e70.randy.dunlap@oracle.com> <20080119212549.GD29070@uranus.ravnborg.org> <200801211138.38591.rusty@rustcorp.com.au> <20080121153409.7511407e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121153409.7511407e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 03:34:09PM -0800, Randy Dunlap wrote:
> On Mon, 21 Jan 2008 11:38:38 +1100 Rusty Russell wrote:
> 
> > On Sunday 20 January 2008 08:25:49 Sam Ravnborg wrote:
> > > On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
> > > > rcu_online_cpu() should be __cpuinit instead of __devinit.
> > >
> > > So if we have:
> > > CONFIG_HOTPLUG=n
> > > CONFIG_HOTPLUG_CPU=y
> > >
> > > then this is a oops candidate.
> > 
> > At first glance, this can't happen because all CONFIG_HOTPLUG_CPU depends on 
> > CONFIG_HOTPLUG or selects it, for all archs.
> 
> Mostly, but arch/mips/ seems to be different (neither depends nor selects)
> unless it has changed very recently (I looked at 2.6.24-rc8).

mips has
	default n

So they at least try to turn off this feature.

	Sam
