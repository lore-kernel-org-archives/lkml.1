Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYGAK5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYGAK5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYGAK5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:57:47 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52213 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYGAK5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:57:46 -0400
Date: Tue, 1 Jul 2008 16:27:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080701105737.GB10403@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080627114109.724249622@chello.nl> <20080627173355.GA11381@linux.vnet.ibm.com> <20080628170828.GA2002@linux.vnet.ibm.com> <20080630125956.GD4011@elte.hu> <20080630145357.GA26809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630145357.GA26809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 08:23:57PM +0530, Dhaval Giani wrote:
> On Mon, Jun 30, 2008 at 02:59:56PM +0200, Ingo Molnar wrote:
> > 
> > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > 
> > > Hi,
> > > 
> > > I get this at bootup
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: at kernel/lockdep.c:2738 check_flags+0x8a/0x12d()
> > > Modules linked in:
> > > Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip #5
> > 
> > please check latest tip/master. This is the commit that should fix it:
> > 
> 
> Nope, does not :(. Still get,
> 

Ah, turns out my git-fetch did not work so well. I just pulled the
latest tip, and it seems to have been fixed. Sorry for the noise.

Thanks,
-- 
regards,
Dhaval
