Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZLBIF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZLBIF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLBIFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:05:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLBIFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:05:54 -0500
Message-ID: <4B161F83.6090804@cn.fujitsu.com>
Date: Wed, 02 Dec 2009 16:04:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Liming Wang <liming.wang@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>, mhiramat@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  perf tools: Add _GNU_SOURCE macro for strndup()
References: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
In-Reply-To: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Liming Wang wrote:
> strndup is a GNU extension. So add _GNU_SOURCE macro
> to avoid compiling error.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/util/string.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 0977cf4..ea3eb39 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,5 +1,8 @@
> +#define _GNU_SOURCE
>  #include <string.h>
>  #include <stdlib.h>
> +
> +#undef _GNU_SOURCE

I think those two "#include" can be removed,
because util.h include it.

>  #include "string.h"
>  #include "util.h"
>  
