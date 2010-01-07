Return-Path: <linux-kernel-owner+w=401wt.eu-S932753Ab0AGBkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0AGBkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530Ab0AGBkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:40:36 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60838 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0AGBkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:40:36 -0500
Date: Thu, 7 Jan 2010 10:34:17 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document
 fixes
Message-Id: <20100107103417.58677878.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
	<20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 10:18:05 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 7 Jan 2010 09:57:14 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > Each memcg-implement-memory-thresholds.patch and
> > memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
> > section to Documentation/cgroup/memory.txt, so the document has been a bit
> > mangled when these patches are merged at the same time.
> > 
> > This patch fixes it.
> > 
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> BTW, I'll prepare total update for memcg (especially around percpu counter).
> Do you have something may conflict in plan ?
> 
Not for now.
Of course, I have a plan that I will add a file/shmem page support to move-charge feature,
but I think we should stabilize and clean up current memcg in mmotm first.
(My biggest concern now is the influence of transparent hugepage to vm and memcg.)


Thanks,
Daisuke Nishimura.
