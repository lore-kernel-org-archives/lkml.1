Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZKEGjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZKEGjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZKEGjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:39:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:16914 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZKEGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xDX1WZjaJvJwhV6R2yMVFWMdxtxMqAOtdNxsejSbxZogJl0YMQ+tirQA1uqQVbxGUP
         ffRfMOJrZUV07KAnQHu+1PoIN6W3oBUiVOcE2++ykPB6aNAnwytovUGnfLvdATh6N8st
         onsPPwq/ApwxWV9kzC8aycIFmzM75D4A9wSec=
Date: Thu, 5 Nov 2009 07:39:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: prevent build warning: 'ftrace_graph_buf'
	defined but not used
Message-ID: <20091105063917.GA4896@nowhere>
References: <4AF24381.5060307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF24381.5060307@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 11:16:17AM +0800, Lai Jiangshan wrote:
> 
> prevent build warning when !CONFIG_FUNCTION_GRAPH_TRACER
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7cb6f19..892e3ea 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2274,7 +2274,6 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
>  #define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
>  static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
>  static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
> -static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>  
>  static int __init set_ftrace_notrace(char *str)
>  {
> @@ -2291,6 +2290,7 @@ static int __init set_ftrace_filter(char *str)
>  __setup("ftrace_filter=", set_ftrace_filter);
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>  static int __init set_graph_function(char *str)
>  {
>  	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
> 

