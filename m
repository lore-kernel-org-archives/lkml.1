Return-Path: <linux-kernel-owner+w=401wt.eu-S932716Ab0AGBnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0AGBnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227Ab0AGBno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:43:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51052 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0AGBnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:43:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 10:40:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document
 fixes
Message-Id: <20100107104018.6fdb2f79.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107103417.58677878.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
	<20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107103417.58677878.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 10:34:17 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Thu, 7 Jan 2010 10:18:05 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 7 Jan 2010 09:57:14 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > Each memcg-implement-memory-thresholds.patch and
> > > memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
> > > section to Documentation/cgroup/memory.txt, so the document has been a bit
> > > mangled when these patches are merged at the same time.
> > > 
> > > This patch fixes it.
> > > 
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > BTW, I'll prepare total update for memcg (especially around percpu counter).
> > Do you have something may conflict in plan ?
> > 
> Not for now.

Okay, thank you. I'll prepare some.

> Of course, I have a plan that I will add a file/shmem page support to move-charge feature,
> but I think we should stabilize and clean up current memcg in mmotm first.
agreed.

> (My biggest concern now is the influence of transparent hugepage to vm and memcg.)
> 
Yes, it's interesting challenge but has concerns for us ;)

Thanks,
-Kame
 

