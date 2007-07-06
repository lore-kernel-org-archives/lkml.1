Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbXGFVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbXGFVST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762322AbXGFVSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:18:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:5648 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762102AbXGFVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CTrF2v9A766Cbg+vdk4ZYo9UYkhWCdVLGhYOTqXRJyUYJT0vfU3dIJLnXlJyVz3N5TSdJwxdTZf+Y7l3ioBlRs5MUC15YkuXrjU2BQJ4vTztypvjo76dq0+SV52p6AXpvhyGb0wrWhRDrlX0CWRG9MwL8KOoNqA2kry/hx8c8yw=
Date: Sat, 7 Jul 2007 01:18:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some love to default profiler
Message-ID: <20070706211803.GB5789@martell.zuzino.mipt.ru>
References: <20070704213420.GA5864@martell.zuzino.mipt.ru> <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 01:50:27AM +0200, Jesper Juhl wrote:
> One tiny comment below.

> >+#define prof_on 0
> >+static inline void profile_init(void)
> >+{
> >+}
>
> Just to be pedantic; don't we want a blank line between functions
> here, even if they are empty?

Dunno, it's boilerplate code, nobody reads it.

> >+static inline void profile_tick(int type)
> >+{
> >+}
> >+static inline void profile_hits(int type, void *ip, unsigned int nr_hits)
> >+{
> >+}
> >+static inline void profile_hit(int type, void *ip)
> >+{
> >+}
> >+static inline void profile_munmap(unsigned long addr)
> >+{
> >+}
> >+static inline void profile_task_exit(struct task_struct *tsk)
> >+{
> >+}
> >+static inline int profile_handoff_task(struct task_struct *tsk)
> >+{
> >+       return 0;
> >+}

