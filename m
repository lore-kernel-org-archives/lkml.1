Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYJ0K0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYJ0K0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYJ0K0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:26:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYJ0K0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:26:24 -0400
Date: Mon, 27 Oct 2008 06:26:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: trace: fix printk warning for u64
In-Reply-To: <20081027174328.084649ab.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0810270626040.3117@gandalf.stny.rr.com>
References: <20081027174328.084649ab.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Oct 2008, Stephen Rothwell wrote:

> A powerpc ppc64_defconfig build produces these warnings:
> 
> kernel/trace/ring_buffer.c: In function 'rb_add_time_stamp':
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type 'u64'
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'u64'
> 
> Just cast the u64s to unsigned long long like we do everywhere else.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

