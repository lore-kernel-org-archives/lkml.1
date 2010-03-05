Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0CEM5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:57:39 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60829 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0CEM5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:57:37 -0500
Date: Fri, 5 Mar 2010 04:57:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, elendil@planet.nl, cloos@jhcloos.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305125730.GA6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100305025435.GA6836@linux.vnet.ibm.com> <1267769448.6392.17.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267769448.6392.17.camel@marge.simson.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 07:10:48AM +0100, Mike Galbraith wrote:
> On Thu, 2010-03-04 at 18:54 -0800, Paul E. McKenney wrote:
> > This patch appends the localversion string to the Linux kernel version.
> > For example, in a git tree with uncommitted changes, the .config file
> > might start as follows (but with leading hash marks):
> > 
> > 	Automatically generated make config: don't edit
> > 	Linux kernel version: 2.6.33-01836-g90a6501-dirty
> > 	Mon Mar  1 17:05:59 2010
> > 
> > The "-01836-g90a6501-dirty" string is added by this patch.
> 
> I really like this.  This gives me the advantages of non-volatile build
> info without the mess that makes if it's appended to file names/paths.

Glad you like it!  ;-)

> 	-Mike
> 
> Eventually someone will make bisect stop stepping on random kernels, and
> generally making a mess, and life will be grand ;-)

Heck, I don't even know how bisect deals with merges.  ;-)

							Thanx, Paul
