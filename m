Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0BXH6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:58:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0BXH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:58:50 -0500
Date: Tue, 23 Feb 2010 23:58:42 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       reiserfs-devel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [Bug #14656] Oops at __rmqueue+0x98 with 2.6.32-rc6
In-Reply-To: <wj3ZQZlk_KB.A.Q0C.hwagLB@chimera>
Message-ID: <alpine.DEB.2.01.1002232323440.28195@bogon.housecafe.de>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.Q0C.hwagLB@chimera>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18MZa9aqAVuudYwklEIYWjbtcs3QL66L+ykDoU
 KY2hQ2d8qEUlqRZz1fvBLT/Ck+7tDJkMoW+/yR+kK5qehHj8VV
 Quk8Fc0z6nu/Rs5h3VCbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas,

On Sun, 21 Feb 2010 at 22:42, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14656
> Subject		: Oops at __rmqueue+0x98 with 2.6.32-rc6
> References : http://marc.info/?l=linux-kernel&m=125860255229092&w=4

Your initial report said:

kernel: BUG: unable to handle kernel paging request at 0000b2cb
kernel: IP: [<c0198266>] __rmqueue+0x98/0x36c


However, the backtraces you posted later (with DEBUG_LIST=y) always 
contained:


------------[ cut here ]------------
WARNING: at lib/list_debug.c:51 list_del+0x41/0x60()
Hardware name: MacBook3,1
list_del corruption. next->prev should be c1b71018, but was 00005095


Not being a kernel hacker, this "list_del corruption" looks kinda weird. At 
one point[0] it was suggested to reproduce this with an untainted 
(ndiswrapper?) kernel; on other occurences[1] some code surgery was indeed 
needed.

I'm afraid I can't help here though, just thinking out loud...

Christian.

[0] http://lkml.org/lkml/2007/1/12/214
[1] http://lkml.org/lkml/2008/9/26/85
    http://lkml.indiana.edu/hypermail/linux/kernel/0902.1/01992.html
-- 
BOFH excuse #275:

Bit rot
