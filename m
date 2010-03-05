Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0CEQCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:02:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab0CEQCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:02:38 -0500
Message-ID: <4B912AE9.90603@redhat.com>
Date: Fri, 05 Mar 2010 11:01:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/6] perf probe: Add missing variable initialization
References: <1267804269-22660-1-git-send-email-acme@infradead.org>
In-Reply-To: <1267804269-22660-1-git-send-email-acme@infradead.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> cc1: warnings being treated as errors
> util/probe-finder.c: In function ‘find_line_range’:
> util/probe-finder.c:172: warning: ‘src’ may be used uninitialized in this function
> make: *** [util/probe-finder.o] Error 1

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

> 
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/probe-finder.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index e77dc88..1e6c65e 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -169,7 +169,7 @@ static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
>  {
>  	Dwarf_Files *files;
>  	size_t nfiles, i;
> -	const char *src;
> +	const char *src = NULL;
>  	int ret;
>  
>  	if (!fname)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
