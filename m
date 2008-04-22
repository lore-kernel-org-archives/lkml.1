Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbYDVPjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbYDVPjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYDVPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:38:51 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:33597 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbYDVPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:38:50 -0400
Date: Tue, 22 Apr 2008 11:38:49 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Will Newton <will.newton@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080422153849.GH19802@phobos.i.cabal.ca>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422081211.e85989ec.randy.dunlap@oracle.com> <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com> <20080422152426.GG19802@phobos.i.cabal.ca> <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:34:03PM +0100, Will Newton wrote:
> On Tue, Apr 22, 2008 at 4:24 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> > On Tue, Apr 22, 2008 at 04:16:17PM +0100, Will Newton wrote:
> >  > It can be done with Kconfig. Whether it should be or not depends on
> >  > your point of view, hence RFC. Currently __ARCH_WANT macros is the way
> >  > syscalls are enabled and disabled across architectures. If there's
> >  > consensus that it should be done via Kconfig that could certainly be
> >  > implmented, but that's a different patch.
> >  >
> >
> >  It's currently done in unistd.h for hysterical raisins. All new
> >  conditional syscalls have been done in Kconfig.
> 
> Do you have a syscall in mind that does this in the correct way?
> 

epoll is the most immediate example at hand, since it touches
fs/compat.c similarly to how you would be touching fs/filesystem.c, and
touches kernel/sys_ni.c and init/Kconfig in much the same way.

> BTW, don't blame the blackfin guys for this, I'm thinking about future
> architectures that may be added rather than any existing ones. ;-)
> 

Meh. :)

cheers, Kyle
