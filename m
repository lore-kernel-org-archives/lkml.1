Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYGKIqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYGKIqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYGKIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:46:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60196 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbYGKIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:46:39 -0400
Date: Fri, 11 Jul 2008 17:52:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
Message-Id: <20080711175213.dc69f068.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080711083446.AC5425A22@siro.lan>
References: <20080711161349.c5831081.kamezawa.hiroyu@jp.fujitsu.com>
	<20080711083446.AC5425A22@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 17:34:46 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> hi,
> 
> > > my patch penalizes heavy-writer cgroups as task_dirty_limit does
> > > for heavy-writer tasks.  i don't think that it's necessary to be
> > > tied to the memory subsystem because i merely want to group writers.
> > > 
> > Hmm, maybe what I need is different from this ;)
> > Does not seem to be a help for memory reclaim under memcg.
> 
> to implement what you need, i think that we need to keep track of
> the numbers of dirty-pages in each memory cgroups as a first step.
> do you agree?
> 
yes, I think so, now.

may be not difficult but will add extra overhead ;( Sigh..



Thanks,
-Kame

