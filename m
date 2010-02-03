Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab0BCVWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:22:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:48946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab0BCVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:22:18 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: balbir@linux.vnet.ibm.com
Subject: Re: Improving OOM killer
Date: Wed, 3 Feb 2010 22:22:15 +0100
User-Agent: KMail/1.9.10
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <201002031310.28271.l.lunak@suse.cz> <20100203122526.GG19641@balbir.in.ibm.com>
In-Reply-To: <20100203122526.GG19641@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002032222.15238.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 of February 2010, Balbir Singh wrote:
> * Lubos Lunak <l.lunak@suse.cz> [2010-02-03 13:10:27]:
> > On Wednesday 03 of February 2010, Balbir Singh wrote:
> > > 2. RSS alone is not sufficient, RSS does not account for shared pages,
> > > so we ideally need something like PSS.
> >
> >  Just to make sure I understand what you mean with "RSS does not account
> > for shared pages" - you say that if a page is shared by 4 processes, then
> > when calculating badness for them, only 1/4 of the page should be counted
> > for each? Yes, I suppose so, that makes sense.
>
> Yes, that is what I am speaking of
>
> > That's more like fine-tunning at
> > this point though, as long as there's no agreement that moving away from
> > VmSize is an improvement.
>
> There is no easy way to calculate the Pss today without walking the
> page tables, but some simplification there will make it a better and a
> more accurate metric.

 OOM should be a rare situation, so doing a little amount of counting 
shouldn't be a big deal. Especially if the machine is otherwise busy waiting 
for the HDD paging stuff out and in again and has plenty of CPU time to 
waste.

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
