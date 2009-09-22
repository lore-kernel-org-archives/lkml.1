Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZIVUfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZIVUfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZIVUfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:35:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:46029 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZIVUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h6yGvTsLyMpaJrCaIwF/nnLGLSsOrazCUelh5PgHV/TSU0tYr2bMjWbGRTult1C7Q9
         MsEEd63iOz/Gv3vxR80uTnOfldcajKZda48z5HvJ499GOlrwaMqd3+Apx/wzdxJddGCN
         G6+3c1G6728WcGC8WlpKCgJcU8NcjWV4LZ/Ig=
Date: Tue, 22 Sep 2009 22:35:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing/workqueue: Use %pf in workqueue trace
	events
Message-ID: <20090922203513.GB5059@nowhere>
References: <20090922023920.GA31801@kryten> <20090922024033.GB31801@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922024033.GB31801@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 12:40:33PM +1000, Anton Blanchard wrote:
> 
> Using %pf instead of %pF supresses printing of the function offset
> which will always be 0.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>


I'll queue this one, thanks!


> ---
> 
> Index: linux.trees.git/include/trace/events/workqueue.h
> ===================================================================
> --- linux.trees.git.orig/include/trace/events/workqueue.h	2009-09-01 15:11:04.000000000 +1000
> +++ linux.trees.git/include/trace/events/workqueue.h	2009-09-14 09:45:41.000000000 +1000
> @@ -26,7 +26,7 @@ TRACE_EVENT(workqueue_insertion,
>  		__entry->func		= work->func;
>  	),
>  
> -	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> +	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
>  		__entry->thread_pid, __entry->func)
>  );
>  
> @@ -48,7 +48,7 @@ TRACE_EVENT(workqueue_execution,
>  		__entry->func		= work->func;
>  	),
>  
> -	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> +	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
>  		__entry->thread_pid, __entry->func)
>  );
>  

