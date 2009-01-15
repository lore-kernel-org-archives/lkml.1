Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbZAOW6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbZAOW6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935406AbZAOWgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:36:02 -0500
Received: from cs-studio.ru ([195.178.208.66]:58092 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935545AbZAOWgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:36:00 -0500
Date: Fri, 16 Jan 2009 01:35:57 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090115223557.GC10429@ioremap.net>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0901152243330.9772@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:50:58PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > This does not work if processes are short-living and are spawned by the
> > parent on demand.
> 
> They will have the same name, too. Your Kenny-killer will fail, too.

It is not always the case, processes start executing different binaries
and change the names, that's at least what I observed in the particular
root case of the discussion.

> > If processes have different priority in regards to oom
> > condition, this problem can not be solved with existing interfaces
> > without changing the application. So effectively there is no solution.
> 
> ACK, but being a child should count. Maybe the weight for childs should be 
> increased, if it does not do the right thing? Or maybe the childs do share 
> much (most of the) memory, so killing the parent is the right thing if you 
> want to free some RAM?

There could be lots of heuristics applied for the different cases, but
without changing the application, they are somewhat limited to
long-living processes only. There are really lots of cases when it does
not stand.

-- 
	Evgeniy Polyakov
