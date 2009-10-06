Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbZJFUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbZJFUNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZJFUM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:12:59 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51512 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755715AbZJFUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:12:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACc+y0pMROOX/2dsb2JhbACBUtJqhCoEgjg
Date: Tue, 6 Oct 2009 16:12:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Breno Leitao <leitao@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: improving tracepoints.txt
Message-ID: <20091006201220.GA3934@Krystal>
References: <1254859771-8873-1-git-send-email-leitao@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1254859771-8873-1-git-send-email-leitao@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:11:20 up 49 days,  7:00,  4 users,  load average: 0.68, 0.29,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Breno Leitao (leitao@linux.vnet.ibm.com) wrote:
> After reading the tracepoints.txt documentation, I tried to
> follow the instructions to run the sample, but just assigning
> CONFIG_SAMPLE_TRACEPOINTS=m wasn't enough to generate the tracepoints
> samples. I also need to set CONFIG_SAMPLES=y, otherwise nothing
> happens.
> 
> So, this silly patch explicit says that CONFIG_SAMPLES should be set to
> compile those files.
> 
> Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>

Yep, good idea. Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  Documentation/trace/tracepoints.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
> index c0e1cee..d380250 100644
> --- a/Documentation/trace/tracepoints.txt
> +++ b/Documentation/trace/tracepoints.txt
> @@ -106,7 +106,7 @@ used to export the defined tracepoints.
>  See the example provided in samples/tracepoints
>  
>  Compile them with your kernel.  They are built during 'make' (not
> -'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
> +'make modules') when CONFIG_SAMPLE=y and CONFIG_SAMPLE_TRACEPOINTS=m.
>  
>  Run, as root :
>  modprobe tracepoint-sample (insmod order is not important)
> -- 
> 1.6.0.4
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
