Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZANTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZANTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZANTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:22:20 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:43498 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZANTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:22:19 -0500
Date: Wed, 14 Jan 2009 22:22:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090114192216.GA18123@ioremap.net>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 08:18:49PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > Mwahaha, I just checked how scores are calculated, so that userspace
> > could adjust them. Let's start with beginning:
> 
> [snip]
> 
> > Do you _REALLY_ think anyone can calculate it yourself and then properly
> > calculate adjustment used to properly select oom-killed process?
> 
> That's easy: Just let your Kenny process run, and check it's score. If it's
> too low, increase the adjustment until it's just above the other processes'
> score. Using binary search, you're done in five steps.
> 
> Then, while you're at it, protect the important programs by setting
> their adjustment to -17.

This does not work if processes are short-living and are spawned by the
parent on demand. If processes have different priority in regards to oom
condition, this problem can not be solved with existing interfaces
without changing the application. So effectively there is no solution.

-- 
	Evgeniy Polyakov
