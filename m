Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbZAHOTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbZAHOTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbZAHOSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:18:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182AbZAHOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:18:54 -0500
Date: Thu, 8 Jan 2009 09:18:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: akpm@linux-foundation.org
cc: mm-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + kernel-trace-ring_bufferc-use-div_round_up-fix.patch added to
 -mm tree
In-Reply-To: <200901080534.n085YHfd019809@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901080918180.22642@gandalf.stny.rr.com>
References: <200901080534.n085YHfd019809@imap1.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Jan 2009, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      kernel-trace-ring_bufferc-use-div_round_up-fix
> has been added to the -mm tree.  Its filename is
>      kernel-trace-ring_bufferc-use-div_round_up-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: kernel-trace-ring_bufferc-use-div_round_up-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> oops
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/trace/ring_buffer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up-fix kernel/trace/ring_buffer.c
> --- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up-fix
> +++ a/kernel/trace/ring_buffer.c
> @@ -150,7 +150,7 @@ rb_event_length(struct ring_buffer_event
>  
>  	case RINGBUF_TYPE_DATA:
>  		if (event->len)
> -			length = event->len / RB_ALIGNMENT;
> +			length = event->len * RB_ALIGNMENT;

OK, I see you spotted the mistake ;-)

-- Steve

>  		else
>  			length = event->array[0];
>  		return length + RB_EVNT_HDR_SIZE;
> _
> 
