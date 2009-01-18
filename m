Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZARU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZARU0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZARUZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:25:59 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:50626 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339AbZARUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:25:58 -0500
Date: Sun, 18 Jan 2009 21:25:49 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090118131303.GA19292@ioremap.net>
Message-ID: <alpine.LSU.0.999.0901182107260.9821@be1.lrz>
References: <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it>
 <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
 <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
 <20090115223557.GC10429@ioremap.net> <alpine.LSU.0.999.0901171504480.7336@be1.lrz>
 <20090117142245.GA10801@ioremap.net> <alpine.LSU.0.999.0901181333160.6179@be1.lrz>
 <20090118131303.GA19292@ioremap.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2009, Evgeniy Polyakov wrote:
> On Sun, Jan 18, 2009 at 01:37:09PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:

> > How many different CGI handlers are you going to have?
> 
> CGIs are usually limited, application server is not.
> 
> > And how does kill-kenny scale with the number of users on the system?
> > I want my browser not to be killed, while the other user wants his
> > gimp not to be killed. As you can see, it does not even scale for
> > the most simple multi-user system.
> 
> It is not about who should not be killed, but who should _be_ in the
> first raw.

If it comes to the killing, it will start with the first row, or using your 
patch, with the only man in the first row, named kenny. Now imagine a 
phalanx of spawned kennies protecting a running-wild application from being 
killed ...

If you set the oom_adj to mark the goat under normal conditions, the system 
will adjust itself to abnormal conditions.

> > > No, admin will limit/forbid the connection from the DoSing clients,
> > > server must always live to handle proper users.
> > 
> > If there is no memory, the admin can't even log in.
> 
> Admin can observe the situation via kvm or sometimes netconsole and
> tune the system for the next run.

So your kill-kenny does not only require having exactly one goat system-wide 
and no process having the same process name, but also constant supervision.
I think it's a really great design!
-- 
Whenever you have plenty of ammo, you never miss. Whenever you are low on
ammo, you can't hit the broad side of a barn.
