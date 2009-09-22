Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZIVUpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZIVUpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZIVUpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:45:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:41604 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZIVUpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pXQjyaOh1XCJZRXvCh7vMZJAYqV/ym/ibGFCq+DY49RqWh1x8MS/n+uNNfp8CP6KNZ
         VeMeTNaAQgRDvZqTSE2P7JvBRlbk+LJXNdqsyfZF/wLTG9gVX9hK4cEOyBtIubxYMz6x
         efwYR4jHGRMSdVCfKmMxZP2pOO/C09A4y2FfM=
Date: Tue, 22 Sep 2009 22:45:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Hong <lihong.hi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix a comment and a trivial format issue in
	tracepoint.h
Message-ID: <20090922204539.GA6062@nowhere>
References: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 06:00:44PM +0800, Li Hong wrote:
> Signed-off-by: Li Hong <lihong.hi@gmail.com>


Queued, thanks!



> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 63a3f7a..2aac8a8 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -4,7 +4,7 @@
>  /*
>   * Kernel Tracepoint API.
>   *
> - * See Documentation/tracepoint.txt.
> + * See Documentation/trace/tracepoints.txt.
>   *
>   * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>   *
> @@ -36,7 +36,7 @@ struct tracepoint {
>  #ifndef DECLARE_TRACE
> 
>  #define TP_PROTO(args...)	args
> -#define TP_ARGS(args...)		args
> +#define TP_ARGS(args...)	args
> 
>  #ifdef CONFIG_TRACEPOINTS
> 
> -- 
> 1.6.0.4

