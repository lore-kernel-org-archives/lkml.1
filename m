Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbYLYALZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbYLYALZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 19:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYLYALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 19:11:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYLYALR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 19:11:17 -0500
Date: Thu, 25 Dec 2008 01:11:03 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH, RESEND3] getrusage: fill ru_maxrss value
Message-ID: <20081225011103.3a81c19d@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081224174248.GA15887@redhat.com>
References: <20081218135945.4f8b87ed@psychotron.englab.brq.redhat.com>
	<20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
	<20081224174248.GA15887@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 18:42:48 +0100
Oleg Nesterov <oleg@redhat.com> wrote:


> > > and we need good comment. e.g. /* Convert to KB */
> > > or good macros (likely linux/fs/proc/meminfo.c::K() macro)
> 
> Yes! Please ;) I just can't parse the code above, I am not compiler.
> Even
> 
> 	r->ru_maxrss *= (PAGE_SIZE / 1024); /* convert pages to KBs */
> 
> is much better, imho. Or at least just add the comment, so the
> poor reader can understand what the code does without parsing.
Fine
> 
> > > In addision, you also need change man pages and notice to linux-api mailing list.
> > I cc'ed this list while I was sending the patch.
> 
> Hmm. The biggest mistake with this patch is that you lost the
> CC list completely ;) Adding Hugh.
> 
> > I was not aware I
> > should change the man page. Will do that too.
> 
> Well. I don't think you must change the man page. Of course it
> would be nice if you do, but in a separate patch please. But
> you must cc Michael at least ;)
I cc'ed him with in my patch post - It has disappeared later in RE. 
> 
> Oleg.
> 
