Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633Ab0ANJQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0ANJQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610Ab0ANJP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:15:59 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40031 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab0ANJP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:15:58 -0500
Date: Thu, 14 Jan 2010 10:15:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       ryov@valinux.co.jp, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroups: blkio subsystem as module
Message-ID: <20100114091557.GO13771@kernel.dk>
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com> <20100108163352.GB22219@redhat.com> <20100112233453.GB5098@unix37.andrew.cmu.edu> <20100112233709.GD5098@unix37.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112233709.GD5098@unix37.andrew.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12 2010, Ben Blum wrote:
> Convert blk-cgroup to be buildable as a module
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch modifies the Block I/O cgroup subsystem to be able to be built as a
> module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
> options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
> enhanced to support the new module dependency.

I'd like to add this for 2.6.34, but I'd like some sign-off(s) on the
cgroup side of things (for patch 1/2).

-- 
Jens Axboe

