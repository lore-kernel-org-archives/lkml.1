Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0CBIPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:15:16 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34269 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab0CBIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:15:14 -0500
Date: Tue, 2 Mar 2010 17:12:14 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-Id: <20100302171214.99f9c73d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100302080056.GA1548@linux>
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
	<1267478620-5276-4-git-send-email-arighi@develer.com>
	<20100302092309.bff454d7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302080056.GA1548@linux>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 09:01:58 +0100, Andrea Righi <arighi@develer.com> wrote:
> On Tue, Mar 02, 2010 at 09:23:09AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon,  1 Mar 2010 22:23:40 +0100
> > Andrea Righi <arighi@develer.com> wrote:
> > 
> > > Apply the cgroup dirty pages accounting and limiting infrastructure to
> > > the opportune kernel functions.
> > > 
> > > Signed-off-by: Andrea Righi <arighi@develer.com>
> > 
> > Seems nice.
> > 
> > Hmm. the last problem is moving account between memcg.
> > 
> > Right ?
> 
> Correct. This was actually the last item of the TODO list. Anyway, I'm
> still considering if it's correct to move dirty pages when a task is
> migrated from a cgroup to another. Currently, dirty pages just remain in
> the original cgroup and are flushed depending on the original cgroup
> settings. That is not totally wrong... at least moving the dirty pages
> between memcgs should be optional (move_charge_at_immigrate?).
> 
FYI, I'm planning to add file-cache and shmem/tmpfs support for move_charge feature
for 2.6.35.
But, hmm, it would be complicated if we try to move dirty account too.


Thanks,
Daisuke Nishimura.
