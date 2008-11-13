Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYKMDXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYKMDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYKMDXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:23:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55078 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYKMDXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:23:20 -0500
Date: Thu, 13 Nov 2008 12:22:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081113122241.b77a0d14.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491B9BB3.6010701@linux.vnet.ibm.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112160758.3dca0b22.akpm@linux-foundation.org>
	<20081113114908.42a6a8a7.kamezawa.hiroyu@jp.fujitsu.com>
	<491B9BB3.6010701@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 08:44:59 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 12 Nov 2008 16:07:58 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >> If we do this then we can make the above "keep" behaviour non-optional,
> >> and the operator gets to choose whether or not to drop the caches
> >> before doing the rmdir.
> >>
> >> Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
> >> interface, and it doesn't have the obvious races which on_rmdir has,
> >> etc.
> >>
> >> hm?
> >>
> > 
> > Balbir, how would you want to do ?
> > 
> > I planned to post shrink_uage patch later (it's easy to be implemented) regardless
> > of acceptance of this patch.
> > 
> > So, I think we should add shrink_usage now and drop this is a way to go.
> 
> I am a bit concerned about dropping stuff at will later. Ubuntu 8.10 has memory
> controller enabled and we exposed memory.force_empty interface there and now
> we've dropped it (bad on our part). I think we should have deprecated it and
> dropped it later.
> 
I *was* documented as "for debug only".

Hmm, adding force_empty again to do "shrink usage to 0" is another choice.

ok?

Thanks,
-Kame

