Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbXJ0Wkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbXJ0Wkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 18:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXJ0Wka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 18:40:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1745 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXJ0Wk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 18:40:29 -0400
Subject: Re: [PATCH] proc_fs.h redux
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, torvalds@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20071027194758.GD9816@martell.zuzino.mipt.ru>
References: <20071027194758.GD9816@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 15:40:04 -0700
Message-Id: <1193524804.26695.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 23:47 +0400, Alexey Dobriyan wrote:
> Remove proc_fs.h from headers that doesn't really need it.

> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -17,6 +17,7 @@
>  #include <linux/errno.h>
>  #include <linux/sched.h>
>  #include <linux/kernel.h>
> +#include <linux/fs.h>

Your code doesn't match your patch description.

You've got new includes of:

<linux/fs.h>
<linux/proc_fs.h>
<linux/err.h>
<linux/kref.h>

and forward declarations of

struct proc_dir_entry;
struct file_operations;

As a general rule, I think it better to use includes
than use naked forward declarations.


