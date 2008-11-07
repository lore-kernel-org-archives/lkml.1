Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYKGX6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYKGX6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYKGX6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:58:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbYKGX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:58:08 -0500
Date: Fri, 7 Nov 2008 15:56:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
Message-Id: <20081107155646.b375413e.akpm@linux-foundation.org>
In-Reply-To: <4914D2DE.9030603@redhat.com>
References: <4914D2DE.9030603@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 18:44:30 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Increase the size of kprobe hash table to 512. It's useful when hundreds
> of kprobes were used in the kernel because current size is just 64.
> 

"useful" is a bit vague.  How big is the problem which this solves, and
how well did it solve it?

See, someone (me) needs to decide whether to merge this and if so,
whether to merge it into 2.6.29, 2.6.28, 2.6.27.x, 2.6.26.x and
2.6.25.x.  I'll need more information to make that decision, but I do
not have it.

> --- 2.6.28-rc3.orig/kernel/kprobes.c
> +++ 2.6.28-rc3/kernel/kprobes.c
> @@ -49,7 +49,7 @@
>  #include <asm/errno.h>
>  #include <asm/uaccess.h>
> 
> -#define KPROBE_HASH_BITS 6
> +#define KPROBE_HASH_BITS 9
>  #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)


