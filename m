Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbXGZJem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbXGZJem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbXGZJed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:34:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXGZJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:34:32 -0400
Date: Thu, 26 Jul 2007 02:34:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070726023401.f6a2fbdf.akpm@linux-foundation.org>
In-Reply-To: <20070726092025.GA9157@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<p73abtkrz37.fsf@bingen.suse.de>
	<46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 11:20:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> Once we give the kernel the knowledge that the dentry wont be used again 
> by this app, the kernel can do a lot more intelligent decision and not 
> baloon the dentry cache.
> 
> ( we _do_ want to baloon the dentry cache otherwise - for things like 
>   "find" - having a fast VFS is important. But known-use-once things 
>   like the daily updatedb job can clearly be annotated properly. )

Mutter.  /proc/sys/vm/vfs_cache_pressure has been there for what, three
years?  Are any distros raising it during the updatedb run yet?
