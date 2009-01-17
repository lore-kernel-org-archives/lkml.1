Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZAQONQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZAQONQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZAQOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:12:59 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:56589 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbZAQOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:12:58 -0500
Date: Sat, 17 Jan 2009 15:12:49 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090115223557.GC10429@ioremap.net>
Message-ID: <alpine.LSU.0.999.0901171504480.7336@be1.lrz>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it>
 <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it>
 <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
 <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
 <20090115223557.GC10429@ioremap.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Evgeniy Polyakov wrote:
> On Thu, Jan 15, 2009 at 10:50:58PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:

> > > This does not work if processes are short-living and are spawned by the
> > > parent on demand.
> > 
> > They will have the same name, too. Your Kenny-killer will fail, too.
> 
> It is not always the case, processes start executing different binaries
> and change the names, that's at least what I observed in the particular
> root case of the discussion.

In that case, you can use a wrapper script.

> > > If processes have different priority in regards to oom
> > > condition, this problem can not be solved with existing interfaces
> > > without changing the application. So effectively there is no solution.
> > 
> > ACK, but being a child should count. Maybe the weight for childs should be 
> > increased, if it does not do the right thing? Or maybe the childs do share 
> > much (most of the) memory, so killing the parent is the right thing if you 
> > want to free some RAM?
> 
> There could be lots of heuristics applied for the different cases, but
> without changing the application, they are somewhat limited to
> long-living processes only. There are really lots of cases when it does
> not stand.

If it's short-lived enough, the processes will out-die the OOM-Killer.
You can only win by by suspending or killing the factory.
-- 
Why do men die before their wives?
They want to.
