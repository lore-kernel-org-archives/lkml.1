Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXJIOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXJIOtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJIOtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:49:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:18829 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXJIOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:49:14 -0400
Date: Tue, 9 Oct 2007 15:48:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Tomasz Chmielewski <mangoo@wpkg.org>
cc: LKML <linux-kernel@vger.kernel.org>, nickpiggin@yahoo.com.au,
       kernel@nn7.de
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
In-Reply-To: <470B7D7E.5070901@wpkg.org>
Message-ID: <Pine.LNX.4.64.0710091544420.22005@blonde.wat.veritas.com>
References: <470B7D7E.5070901@wpkg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Tomasz Chmielewski wrote:
> 
> I had a similar issue with 2.6.22.9, but as I had a proprietary nvidia module
> loaded, I didn't report it. X was not enabled, though.

There is indeed a strong likelihood that yours is
related to that nvidia(P): please take it to them.

Hugh

> Oct  3 10:14:09 tomek kernel: Eeek! page_mapcount(page) went negative! (-1)
> Oct  3 10:14:09 tomek kernel:   page pfn = 13aa
> Oct  3 10:14:10 tomek kernel:   page->flags = 40000400
> Oct  3 10:14:10 tomek kernel:   page->count = 1
> Oct  3 10:14:10 tomek kernel:   page->mapping = 00000000
> Oct  3 10:14:10 tomek kernel:   vma->vm_ops = 0x0
> Oct  3 10:14:10 tomek kernel: ------------[ cut here ]------------
> Oct  3 10:14:10 tomek syslogd: /dev/tty12: Interrupted system call
> Oct  3 10:14:10 tomek kernel: kernel BUG at mm/rmap.c:628!
> Oct  3 10:14:10 tomek kernel: invalid opcode: 0000 [#1]
> Oct  3 10:14:10 tomek kernel: PREEMPT
> Oct  3 10:14:10 tomek kernel: Modules linked in: nvidia(P) ...
> Oct  3 10:14:10 tomek kernel: CPU:    0
> Oct  3 10:14:10 tomek kernel: EIP:    0060:[<c015a434>]    Tainted: P     VLI
> Oct  3 10:14:10 tomek kernel: EFLAGS: 00010246   (2.6.22.9-3 #1)
> Oct  3 10:14:10 tomek kernel: EIP is at page_remove_rmap+0xd7/0x105
