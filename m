Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZLJBbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZLJBbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbZLJBbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:31:04 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43994 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZLJBbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:31:03 -0500
Date: Thu, 10 Dec 2009 10:16:27 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for
 root cgroup
Message-Id: <20091210101627.1a9bd484.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091209162109.567ff5fa.akpm@linux-foundation.org>
References: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
	<20091210085929.56c63eb2.kamezawa.hiroyu@jp.fujitsu.com>
	<20091209162109.567ff5fa.akpm@linux-foundation.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 16:21:09 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
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
> If so, why?
> 
Well, the value of <root cgroup>/memory.memsw.usage_in_bytes would be incorrect
(swap usage would not be counted) without this patch. So the impact of this bug
depends on how the value is used.

Anyway, this bug exists only in 2.6.32 and this patch can be applied onto it
without any change.


Thanks,
Daisuke Nishimura.
