Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbYLKTs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbYLKTs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYLKTXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:23:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbYLKTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:23:05 -0500
Date: Thu, 11 Dec 2008 14:23:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/9] ring_buffer: add remaining cpu functions to
 ring_buffer.h
In-Reply-To: <1229013723-8191-6-git-send-email-robert.richter@amd.com>
Message-ID: <alpine.DEB.1.10.0812111422180.24741@gandalf.stny.rr.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com> <1229013723-8191-6-git-send-email-robert.richter@amd.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Dec 2008, Robert Richter wrote:

> These functions are not yet in ring_buffer.h though they seems to be
> part of the API.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/linux/ring_buffer.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index e097c2e..de9d8c1 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -116,6 +116,8 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
>  
>  unsigned long ring_buffer_entries(struct ring_buffer *buffer);
>  unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
> +unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
> +unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
>  
>  u64 ring_buffer_time_stamp(int cpu);
>  void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
> -- 
> 1.6.0.1
> 
> 
> 
> 
