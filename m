Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZCTNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZCTNK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZCTNKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:10:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZCTNKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:10:43 -0400
Date: Fri, 20 Mar 2009 10:10:17 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] blktrace: report EBUSY correctly
Message-ID: <20090320131017.GN30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F614.2010101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F614.2010101@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:49:08AM +0800, Li Zefan escreveu:
> blk_trace_remove_queue() returns EINVAL if q->blk_trace == NULL,
> but blk_trace_setup_queue() doesn't return EBUSY if q->blk_trace != NULL.
> 
>  # echo 0 > sdaX/trace/enable
>  # echo 0 > sdaX/trace/enable
>  bash: echo: write error: Invalid argument
>  # echo 1 > sdaX/trace/enable
>  # echo 1 > sdaX/trace/enable
>  (should return EBUSY)
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks for all the testing, its being really appreciated,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
