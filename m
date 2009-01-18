Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZARUlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZARUlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZARUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:41:00 -0500
Received: from tservice.ru ([195.178.208.66]:60128 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZARUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:40:59 -0500
Date: Sun, 18 Jan 2009 23:41:00 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090118204100.GA31507@ioremap.net>
References: <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz> <20090115223557.GC10429@ioremap.net> <alpine.LSU.0.999.0901171504480.7336@be1.lrz> <20090117142245.GA10801@ioremap.net> <alpine.LSU.0.999.0901181333160.6179@be1.lrz> <20090118131303.GA19292@ioremap.net> <alpine.LSU.0.999.0901182107260.9821@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0901182107260.9821@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 09:25:49PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > It is not about who should not be killed, but who should _be_ in the
> > first raw.
> 
> If it comes to the killing, it will start with the first row, or using your 
> patch, with the only man in the first row, named kenny. Now imagine a 
> phalanx of spawned kennies protecting a running-wild application from being 
> killed ...
>
> If you set the oom_adj to mark the goat under normal conditions, the system 
> will adjust itself to abnormal conditions.

Admin who sets is up knows what he is doing. Hope you will not argue
about the case, when admin will disable the oom-killer and will not be
able to log in.

Once again: this is an additional tunable which allows to easily solve
the problem showed here multiple times. And whily you did not try to
tune oom-adj yourself you continue arguing that it works the best. It
does not. Any solution for the showed problem is not a simple and
nice-looking, the one I proposed imo looks the most convenient for the
people who really work with the systems where described behaviour was
observed.

> > > > No, admin will limit/forbid the connection from the DoSing clients,
> > > > server must always live to handle proper users.
> > > 
> > > If there is no memory, the admin can't even log in.
> > 
> > Admin can observe the situation via kvm or sometimes netconsole and
> > tune the system for the next run.
> 
> So your kill-kenny does not only require having exactly one goat system-wide 
> and no process having the same process name, but also constant supervision.
> I think it's a really great design!

You should reread (better twice) what we are talking about here and what
and why patch was proposed. And how it works too.

-- 
	Evgeniy Polyakov
