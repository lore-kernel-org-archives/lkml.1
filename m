Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355Ab0ALAYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0ALAYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088Ab0ALAYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:24:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47609 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0ALAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:24:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 09:21:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, axboe@kernel.dk, ryov@valinux.co.jp,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 2/2] cgroups: blkio subsystem as module
Message-Id: <20100112092106.9ac4e535.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100108151038.GA22219@redhat.com>
References: <20091231051050.GA714@andrew.cmu.edu>
	<20100106160414.bd555474.akpm@linux-foundation.org>
	<20100107012606.GA25577@andrew.cmu.edu>
	<20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
	<4B45824B.9030108@cn.fujitsu.com>
	<20100108052734.GA13168@andrew.cmu.edu>
	<20100108053021.GC13168@andrew.cmu.edu>
	<20100108151038.GA22219@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 10:10:38 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jan 08, 2010 at 12:30:21AM -0500, Ben Blum wrote:
> > Convert blk-cgroup to be buildable as a module
> > 
> > From: Ben Blum <bblum@andrew.cmu.edu>
> > 
> > This patch modifies the Block I/O cgroup subsystem to be able to be built as a
> > module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
> > options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
> > enhanced to support the new module dependency.
> > 
> 
> Hi Ben,
> 
> I will give this patch a try. 
> 
> So from blk-cgroup perspective, the advantage of allowing it as module
> will be that we can save some memory if we are not using the controller?
> 
Is "moduled" blkio cgroup safe after page-tracking by page_cgroup is
introduced ? 

Thanks,
-Kame

