Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYCKPIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYCKPIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYCKPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:07:55 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:55592 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYCKPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:07:54 -0400
Subject: Re: [PATCH] sysrq show-all-cpus
From: Jon Masters <jonathan@jonmasters.org>
To: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lwoodman@redhat.com
In-Reply-To: <20080311100750.01464a5c@bree.surriel.com>
References: <20080310133242.0ab69084@bree.surriel.com>
	 <20080310104628.b70af419.randy.dunlap@oracle.com>
	 <20080310140315.1a451092@bree.surriel.com>
	 <1205219904.27299.100.camel@perihelion>
	 <20080311100750.01464a5c@bree.surriel.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 11 Mar 2008 11:06:56 -0400
Message-Id: <1205248016.27299.110.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-11 at 10:07 -0400, Rik van Riel wrote:
> On Tue, 11 Mar 2008 03:18:24 -0400
> Jon Masters <jonathan@jonmasters.org> wrote:
> 
> > On Mon, 2008-03-10 at 14:03 -0400, Rik van Riel wrote:
> > > SysRQ-P is not always useful on SMP systems, since it usually ends up showing the
> > > backtrace of a CPU that is doing just fine, instead of the backtrace of the CPU
> > > that is having problems.
> > > 
> > > This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every active
> > > CPU in the system.  It skips idle CPUs because some SMP systems are just too large
> > > and we already know what the backtrace of the idle task looks like.
> > >  
> > > Signed-off-by: Rik van Riel <riel@redhat.com>
> > 
> > Why not have it just print the local CPU on non-SMP anyway?
> 
> Sysrq p already does exactly that.

That's my point. I understand why there's a new command, because it is
different from 'p', but probably worth doing something on non-SMP too.

Jon.


