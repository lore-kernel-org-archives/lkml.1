Return-Path: <linux-kernel-owner+w=401wt.eu-S933403AbZARMh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbZARMh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZARMhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:37:18 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:35746 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbZARMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:37:16 -0500
Date: Sun, 18 Jan 2009 13:37:09 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090117142245.GA10801@ioremap.net>
Message-ID: <alpine.LSU.0.999.0901181333160.6179@be1.lrz>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it>
 <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it>
 <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
 <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
 <20090115223557.GC10429@ioremap.net> <alpine.LSU.0.999.0901171504480.7336@be1.lrz>
 <20090117142245.GA10801@ioremap.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009, Evgeniy Polyakov wrote:

> On Sat, Jan 17, 2009 at 03:12:49PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > > > > This does not work if processes are short-living and are spawned by the
> > > > > parent on demand.
> > > > 
> > > > They will have the same name, too. Your Kenny-killer will fail, too.
> > > 
> > > It is not always the case, processes start executing different binaries
> > > and change the names, that's at least what I observed in the particular
> > > root case of the discussion.
> > 
> > In that case, you can use a wrapper script.
> 
> That may be a solution, except that not very convenient, since there may
> be really lots of executables and cooking up a special script for
> everyone will not scale well.

How many different CGI handlers are you going to have?

And how does kill-kenny scale with the number of users on the system?
I want my browser not to be killed, while the other user wants his
gimp not to be killed. As you can see, it does not even scale for
the most simple multi-user system.

> > > There could be lots of heuristics applied for the different cases, but
> > > without changing the application, they are somewhat limited to
> > > long-living processes only. There are really lots of cases when it does
> > > not stand.
> > 
> > If it's short-lived enough, the processes will out-die the OOM-Killer.
> > You can only win by by suspending or killing the factory.
> 
> No, admin will limit/forbid the connection from the DoSing clients,
> server must always live to handle proper users.

If there is no memory, the admin can't even log in.
-- 
Programming is an art form that fights back.
