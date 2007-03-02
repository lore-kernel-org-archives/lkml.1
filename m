Return-Path: <linux-kernel-owner+w=401wt.eu-S1751069AbXCBVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbXCBVlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbXCBVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:41:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35619 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXCBVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:19 -0500
Date: Fri, 2 Mar 2007 13:41:11 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: "Alexander Y. Fomichev" <gluk@php4.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
Subject: Re: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Message-ID: <20070302214111.GL10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	"Alexander Y. Fomichev" <gluk@php4.ru>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	admin@list.net.ru
References: <200703021651.16050.gluk@php4.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703021651.16050.gluk@php4.ru>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 04:51:15PM +0300, Alexander Y. Fomichev wrote:
> I'm hit a bug on 2.6.21-rc1 at startup of mysql with 'large-pages' flag set.
> (at this point mysql trying to allocate pages from hugetlb pool by sysv 
> shm syscalls). Seems like it could be triggered by previous badness
> and probably hugetlb itself is not related. Anyway i couldn't reproduce
> it by now with 2.6.21-rc2 git commit 562aa1d4c6a874373f9a48ac184f662fbbb06a04.
> Very likely it has been fixed somwhere between 2.6.21-rc1 and -rc2,
> but i couldn't find something related by git log so any comments are welcome.

If you have a known-working kernel version, git-bisect might help you
track down where it was introduced. Given the messages prior to the
hugetlbpage.c BUG_ON I'd say that this is something else besides the
specific code listed by line number, though I wouldn't rule out hugetlb
having tripped over itself before the actual BUG.


-- wli
