Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYBRNBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYBRNBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbYBRNAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:00:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760364AbYBRNAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:00:41 -0500
Date: Mon, 18 Feb 2008 04:59:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
Message-Id: <20080218045918.2b80ee08.akpm@linux-foundation.org>
In-Reply-To: <1203058021.3027.143.camel@ymzhang>
References: <1203058021.3027.143.camel@ymzhang>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 14:47:01 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> Call Trace:
>  [<ffffffff805e0024>] ? __alloc_skb+0x31/0x121
>  [<ffffffff805dc389>] ? sock_alloc_send_skb+0x77/0x1d2
>  [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff805e12d5>] ? memcpy_fromiovec+0x36/0x66
>  [<ffffffff80636ec0>] ? unix_stream_sendmsg+0x165/0x333
>  [<ffffffff805d9863>] ? sock_aio_write+0xd1/0xe0
>  [<ffffffff80227834>] ? __wake_up_common+0x41/0x74
>  [<ffffffff8027d267>] ? do_sync_write+0xc9/0x10c
>  [<ffffffff80265fbb>] ? __do_fault+0x382/0x3cd
>  [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff80268840>] ? handle_mm_fault+0x38a/0x70d
>  [<ffffffff806afd39>] ? error_exit+0x0/0x51
>  [<ffffffff80228008>] ? __dequeue_entity+0x1c/0x32
>  [<ffffffff8027d9bb>] ? vfs_write+0xc0/0x136
>  [<ffffffff8027dee5>] ? sys_write+0x45/0x6e
>  [<ffffffff8020bdcb>] ? system_call_after_swapgs+0x7b/0x80

off-topic, but...  Why are all the backtrace decodes here marked as
being unreliable?
