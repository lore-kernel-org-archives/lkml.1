Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab0BYR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:56:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab0BYR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:56:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=kU0KA3x0u1MA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=kS5g1J_g_e-grJbofHAA:9 a=p_Eez4pZyMdSSO9snjmKkHZ_srIA:4 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][trace-cmd] trace-record: wrong refferencing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1267119647-16775-1-git-send-email-jolsa@redhat.com>
References: <1267119647-16775-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 12:56:12 -0500
Message-ID: <1267120572.6328.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 18:40 +0100, Jiri Olsa wrote:
> hi,
> 
> looks like bug this time :)

Indeed it is.

Applied, thanks!

-- Steve

> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> diff --git a/trace-record.c b/trace-record.c
> index cdfc857..2a754b9 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -116,7 +116,7 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu)
>  	int fd;
>  
>  	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
> -	if (recorder->fd < 0)
> +	if (fd < 0)
>  		return NULL;
>  
>  	recorder = tracecmd_create_recorder_fd(fd, cpu);


