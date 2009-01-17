Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZAQOW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZAQOW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZAQOWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:22:48 -0500
Received: from kandzendo.ru ([195.178.208.66]:37231 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZAQOWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:22:47 -0500
Date: Sat, 17 Jan 2009 17:22:45 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090117142245.GA10801@ioremap.net>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz> <20090115223557.GC10429@ioremap.net> <alpine.LSU.0.999.0901171504480.7336@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0901171504480.7336@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 03:12:49PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > > > This does not work if processes are short-living and are spawned by the
> > > > parent on demand.
> > > 
> > > They will have the same name, too. Your Kenny-killer will fail, too.
> > 
> > It is not always the case, processes start executing different binaries
> > and change the names, that's at least what I observed in the particular
> > root case of the discussion.
> 
> In that case, you can use a wrapper script.

That may be a solution, except that not very convenient, since there may
be really lots of executables and cooking up a special script for
everyone will not scale well.

> > There could be lots of heuristics applied for the different cases, but
> > without changing the application, they are somewhat limited to
> > long-living processes only. There are really lots of cases when it does
> > not stand.
> 
> If it's short-lived enough, the processes will out-die the OOM-Killer.
> You can only win by by suspending or killing the factory.

No, admin will limit/forbid the connection from the DoSing clients,
server must always live to handle proper users.

-- 
	Evgeniy Polyakov
