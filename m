Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZKWUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZKWUDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZKWUDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:03:18 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55199 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZKWUDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wR75lZmH0TTN2myIdxA6GHsyglkYPMIs29mBQsGZHYlqf7v7v5LD0Zpnp9pbSIx3GY
         JnVTZqjLogj1nyXI4VkCE1j7vskqFW2Hjc+ujK5vmEkkwCWlHmeLbauI7V+R4s4VTfnh
         T7GvqGq8DZYsCEYqhm6ctNnpaIihrwEC+KIHA=
MIME-Version: 1.0
In-Reply-To: <1259005869-13487-2-git-send-email-acme@infradead.org>
References: <1259005869-13487-1-git-send-email-acme@infradead.org>
	 <1259005869-13487-2-git-send-email-acme@infradead.org>
Date: Mon, 23 Nov 2009 22:03:19 +0200
X-Google-Sender-Auth: fdea3e59c6239380
Message-ID: <84144f020911231203p2e4afd11tc5068c55cf2b1d12@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf kmem: resolve symbols
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 9:51 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> E.g.
>
> [root@doppio linux-2.6-tip]# perf kmem record sleep 3s
> [ perf record: Woken up 2 times to write data ]
> [ perf record: Captured and wrote 0.804 MB perf.data (~35105 samples) ]
> [root@doppio linux-2.6-tip]# perf kmem --stat caller | head -10
> ------------------------------------------------------------------------------
> Callsite                    |Total_alloc/Per | Total_req/Per | Hit  | Frag
> ------------------------------------------------------------------------------
> getname/40                  | 1519616/4096   | 1519616/4096  |   371|   0.000%
> seq_read/a2                 |  987136/4096   |  987136/4096  |   241|   0.000%
> __netdev_alloc_skb/43       |  260368/1049   |  259968/1048  |   248|   0.154%
> __alloc_skb/5a              |   77312/256    |   77312/256   |   302|   0.000%
> proc_alloc_inode/33         |   76480/632    |   76472/632   |   121|   0.010%
> get_empty_filp/8d           |   70272/192    |   70272/192   |   366|   0.000%
> split_vma/8e                |   42064/176    |   42064/176   |   239|   0.000%
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

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
