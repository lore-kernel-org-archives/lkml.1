Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZCTNEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZCTNEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZCTNEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:04:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZCTNEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:04:36 -0400
Date: Fri, 20 Mar 2009 10:04:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] blktrace: don't increase blk_probes_ref if failed
	to setup blk trace
Message-ID: <20090320130401.GK30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F5FF.80002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F5FF.80002@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:48:47AM +0800, Li Zefan escreveu:
> do_blk_trace_setup() may return EBUSY, but the current code doesn't
> decrease blk_probes_ref in this case.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks valid,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
