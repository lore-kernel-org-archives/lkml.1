Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbZAOVvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbZAOVvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAOVvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:51:10 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:59900 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbZAOVvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:51:08 -0500
Date: Thu, 15 Jan 2009 22:50:58 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090114192216.GA18123@ioremap.net>
Message-ID: <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it>
 <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it>
 <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
 <20090114192216.GA18123@ioremap.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:
> On Wed, Jan 14, 2009 at 08:18:49PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:

> > > Mwahaha, I just checked how scores are calculated, so that userspace
> > > could adjust them. Let's start with beginning:
> > 
> > [snip]
> > 
> > > Do you _REALLY_ think anyone can calculate it yourself and then properly
> > > calculate adjustment used to properly select oom-killed process?
> > 
> > That's easy: Just let your Kenny process run, and check it's score. If it's
> > too low, increase the adjustment until it's just above the other processes'
> > score. Using binary search, you're done in five steps.
> > 
> > Then, while you're at it, protect the important programs by setting
> > their adjustment to -17.
> 
> This does not work if processes are short-living and are spawned by the
> parent on demand.

They will have the same name, too. Your Kenny-killer will fail, too.

> If processes have different priority in regards to oom
> condition, this problem can not be solved with existing interfaces
> without changing the application. So effectively there is no solution.

ACK, but being a child should count. Maybe the weight for childs should be 
increased, if it does not do the right thing? Or maybe the childs do share 
much (most of the) memory, so killing the parent is the right thing if you 
want to free some RAM?

-- 
The complexity of a weapon is inversely proportional to the IQ of the
weapon's operator.
