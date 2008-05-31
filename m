Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYEaErV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYEaErV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYEaErK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:47:10 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:40964 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYEaErJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:47:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=cSE6cCm9PVjWiIo+1do7fO8xWr3SLURaiCpvirXqF3WUzll2yU4R/J9cjZjZholj;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 31 May 2008 00:47:03 -0400
From: Bill Fink <billfink@mindspring.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-Id: <20080531004703.a081c18f.billfink@mindspring.com>
In-Reply-To: <20080530194113.25b77988@extreme>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<20080530151250.b44a119a.billfink@mindspring.com>
	<48407C51.7090405@hp.com>
	<20080530210931.5970c975.billfink@mindspring.com>
	<20080530194113.25b77988@extreme>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4db6a4afc500d00fc244c0080c999f83b4350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Stephen Hemminger wrote:

> On Fri, 30 May 2008 21:09:31 -0400
> Bill Fink <billfink@mindspring.com> wrote:
> 
> > On Fri, 30 May 2008, Rick Jones wrote:
> > 
> > > > Saving stats output and running beforeafter on a number of systems is
> > > > a royal pain when troubleshooting.
> > > 
> > > Well, with that ringing endorsement :) I would like to state that 
> > > Yoshihiro Ishijima has fixed some bugs in beforeafter and it will now 
> > > deal with /proc/interrupts output better than before.
> > > 
> > > ftp://ftp.cup.hp.com/dist/networking/tools/
> > 
> > Nothing against beforefter.  It's a very useful tool, especially
> > given Linux's lack of a method to clear interface counters.  But
> > it still is very cumbersome to use in the scenario I mentioned,
> > having to save the stats before and after a test on each of several
> > systems, and then having to run beforeafter on each of those systems.
> > Then you need to do this all again for every test run.  It's just
> > not very efficient.
> > 
> > I don't know why the major objection to adding a small amount of
> > code to the kernel that would make life a lot easier for hundreds
> > (or more) of Linux network adminstrators.  And the snapshot/diff
> > idea would not be complex to maintain and would also address the
> > issue of some hardware not having a clear hw stats capability.
> > 
> > 						-Bill
> 
> ifstat from iproute2 tools also keeps state to compute number
> of packets since last update as well. Come on, it isn't that
> hard.

Thanks for the pointer.  I wasn't aware of ifstat (it's not installed
by default on any of my systems).  I will check out ifstat and see what
it can do.

						-Thanks

						-Bill
