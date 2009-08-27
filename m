Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZH0DeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZH0DeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZH0DeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:34:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZH0DeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:34:12 -0400
Date: Wed, 26 Aug 2009 23:34:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing: block-able ring_buffer consumer
In-Reply-To: <4A95F71C.1060607@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908262333580.18923@gandalf.stny.rr.com>
References: <4A95F71C.1060607@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Lai Jiangshan wrote:

> 
> The first patch fixes a bug of splice_read for ring_buffer, and makes
> rb_get_reader_page() can be easily used by block-able/poll-able codes.
> 
> The other patches make consumer block-able and poll-able.

Hi Lai,

Thanks, I'll take a look at these patches tomorrow.

-- Steve

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  b/include/linux/ftrace.h      |    6 ++
>  b/include/linux/ring_buffer.h |    4 +
>  b/kernel/timer.c              |    2
>  b/kernel/trace/ring_buffer.c  |   29 +++++++------
>  b/kernel/trace/trace.c        |   39 ++++++++++++++++--
>  include/linux/ring_buffer.h   |    3 +
>  kernel/trace/ring_buffer.c    |   89 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c          |    9 ++++
>  8 files changed, 163 insertions(+), 18 deletions(-)
> 
> 
> 
> 
> 
