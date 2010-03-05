Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab0CEGK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:10:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:59722 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750888Ab0CEGKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:10:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/QGtxPO+TQntZJTrHkdObBQ8q5MCS0THFFQZZjIB
	QMGrUynp4OgJUD
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, elendil@planet.nl, cloos@jhcloos.com
In-Reply-To: <20100305025435.GA6836@linux.vnet.ibm.com>
References: <20100305025435.GA6836@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 07:10:48 +0100
Message-Id: <1267769448.6392.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.60999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 18:54 -0800, Paul E. McKenney wrote:
> This patch appends the localversion string to the Linux kernel version.
> For example, in a git tree with uncommitted changes, the .config file
> might start as follows (but with leading hash marks):
> 
> 	Automatically generated make config: don't edit
> 	Linux kernel version: 2.6.33-01836-g90a6501-dirty
> 	Mon Mar  1 17:05:59 2010
> 
> The "-01836-g90a6501-dirty" string is added by this patch.

I really like this.  This gives me the advantages of non-volatile build
info without the mess that makes if it's appended to file names/paths.

	-Mike

Eventually someone will make bisect stop stepping on random kernels, and
generally making a mess, and life will be grand ;-)

