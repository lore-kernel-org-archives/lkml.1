Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbZLJBQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbZLJBQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZLJBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:16:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57304 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZLJBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:16:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 10:13:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for
 root cgroup
Message-Id: <20091210101355.d94988cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091209162109.567ff5fa.akpm@linux-foundation.org>
References: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
	<20091210085929.56c63eb2.kamezawa.hiroyu@jp.fujitsu.com>
	<20091209162109.567ff5fa.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 16:21:09 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009 08:59:29 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed,  9 Dec 2009 17:48:58 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > We really want to take MEM_CGROUP_STAT_SWAPOUT into account.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > Cc: stable@kernel.org
> > 
> > Thanks.
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> 
> Is this bug sufficiently serious to justify a -stable backport?
> 
I think so.

> If so, why?
> 

memory cgroup has a file memory.memsw.usage_in_bytes file. It shows sum of
the usage of pages and swapents in the cgroup.  Now, root cgroup's 
memsw.usage_in_bytes shows wrong value....the number of swapents are not
added. This patch fixesi it.

Thanks,
-Kame

