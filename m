Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZHQCwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZHQCwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZHQCwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:52:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37240 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbZHQCwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:52:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Aug 2009 11:50:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] kcore clean up and enhance
Message-Id: <20090817115052.d512a294.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090812094309.GB5929@cr0.nay.redhat.com>
References: <20090806192416.4f94be76.kamezawa.hiroyu@jp.fujitsu.com>
	<20090812094309.GB5929@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 17:43:09 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Thu, Aug 06, 2009 at 07:24:16PM +0900, KAMEZAWA Hiroyuki wrote:
> >
> >This patch set is for /proc/kcore. By this,
> >
> > - many per-arch hooks are removed.
> >
> > - /proc/kcore will know really valid physical memory area.
> >
> > - /proc/kcore will be aware of memory hotplug.
> >
> > - /proc/kcore will be architecture independent i.e.
> >   if an arch supports CONFIG_MMU, it can use /proc/kcore.
> >   (if the arch uses usual memory layout.)
> 
> 
> 
> Hi, this version looks fine for me, I can't spot any obvious
> mistakes now.
> 
> I would like to see these patches merged into -mm, so that
> I can test the whole stuff about /proc/kcore.
> 
> Andrew, could you take these?
> 
I'm back. I'll rewrite a rebased one to the newest rc(or mmotm)
and check it.

Thanks,
-Kame

