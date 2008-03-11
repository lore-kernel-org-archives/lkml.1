Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYCKOJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYCKOJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYCKOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:09:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYCKOJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:09:25 -0400
Date: Tue, 11 Mar 2008 10:07:50 -0400
From: Rik van Riel <riel@redhat.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH] sysrq show-all-cpus
Message-ID: <20080311100750.01464a5c@bree.surriel.com>
In-Reply-To: <1205219904.27299.100.camel@perihelion>
References: <20080310133242.0ab69084@bree.surriel.com>
	<20080310104628.b70af419.randy.dunlap@oracle.com>
	<20080310140315.1a451092@bree.surriel.com>
	<1205219904.27299.100.camel@perihelion>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 03:18:24 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> On Mon, 2008-03-10 at 14:03 -0400, Rik van Riel wrote:
> > SysRQ-P is not always useful on SMP systems, since it usually ends up showing the
> > backtrace of a CPU that is doing just fine, instead of the backtrace of the CPU
> > that is having problems.
> > 
> > This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every active
> > CPU in the system.  It skips idle CPUs because some SMP systems are just too large
> > and we already know what the backtrace of the idle task looks like.
> >  
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> Why not have it just print the local CPU on non-SMP anyway?

Sysrq p already does exactly that.

-- 
All rights reversed.
