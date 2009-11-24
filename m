Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZKXAvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZKXAvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZKXAvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:51:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZKXAvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:51:32 -0500
Message-ID: <4B0B2DF1.1010603@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 08:50:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       =?UTF-8?B?RnLDqQ==?= =?UTF-8?B?ZMOpcmljIFdlaXNiZWNrZXI=?= 
	<fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] perf kmem: resolve symbols
References: <1259005869-13487-1-git-send-email-acme@infradead.org> <1259005869-13487-2-git-send-email-acme@infradead.org>
In-Reply-To: <1259005869-13487-2-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> E.g.
> 
> [root@doppio linux-2.6-tip]# perf kmem record sleep 3s
> [ perf record: Woken up 2 times to write data ]
> [ perf record: Captured and wrote 0.804 MB perf.data (~35105 samples) ]
> [root@doppio linux-2.6-tip]# perf kmem --stat caller | head -10
> ------------------------------------------------------------------------------
> Callsite                    |Total_alloc/Per | Total_req/Per | Hit  | Frag
> ------------------------------------------------------------------------------
> getname/40                  | 1519616/4096   | 1519616/4096  |   371|   0.000%
> seq_read/a2                 |  987136/4096   |  987136/4096  |   241|   0.000%
> __netdev_alloc_skb/43       |  260368/1049   |  259968/1048  |   248|   0.154%
> __alloc_skb/5a              |   77312/256    |   77312/256   |   302|   0.000%
> proc_alloc_inode/33         |   76480/632    |   76472/632   |   121|   0.010%
> get_empty_filp/8d           |   70272/192    |   70272/192   |   366|   0.000%
> split_vma/8e                |   42064/176    |   42064/176   |   239|   0.000%
> [root@doppio linux-2.6-tip]#
> 
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: linux-mm@kvack.org <linux-mm@kvack.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-kmem.c |   37 +++++++++++++++++++++++--------------
>  1 files changed, 23 insertions(+), 14 deletions(-)

I was about to send out my version. Any, thanks for doing this!

