Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188Ab0AYVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0AYVkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822Ab0AYVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:40:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0AYVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:40:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=whUijNTEeaUA:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=WmSqnoh-cl0rduE8UdkA:9 a=Jy4lXIASVxSFHk_YKnUA:7 a=s0WndkzCh9Mf643VYZinsIh3pNgA:4 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] trace/trace_output.c: fix "integer as NULL
 pointer" warning.
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Thiago Farina <tfransosi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
	 <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 25 Jan 2010 16:40:31 -0500
Message-ID: <1264455631.31321.433.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-24 at 11:03 -0500, Thiago Farina wrote:
> kernel/trace/trace_output.c:256:24: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

Is this going through some other tree, or should I just pull it?

-- Steve

> ---
>  kernel/trace/trace_output.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 8e46b33..2404c12 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
>  	void *ret;
>  
>  	if (s->full)
> -		return 0;
> +		return NULL;
>  
>  	if (len > ((PAGE_SIZE - 1) - s->len)) {
>  		s->full = 1;


