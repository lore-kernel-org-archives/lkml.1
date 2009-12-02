Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZLBQvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZLBQvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZLBQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:51:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZLBQvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:51:51 -0500
Message-ID: <4B169B20.80400@redhat.com>
Date: Wed, 02 Dec 2009 11:51:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Liming Wang <liming.wang@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: fix compiling error for strndup
References: <1259740750-12646-1-git-send-email-liming.wang@windriver.com>
In-Reply-To: <1259740750-12646-1-git-send-email-liming.wang@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liming Wang wrote:
> Remove redundant include files to avoid compiling error.
> 
> Signed-off-by: Liming Wang<liming.wang@windriver.com>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> Acked-by: Frederic Weisbecker<fweisbec@gmail.com>

Thanks for fixing it!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>   tools/perf/util/string.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 0977cf4..f24a8cc 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,5 +1,3 @@
> -#include<string.h>
> -#include<stdlib.h>
>   #include "string.h"
>   #include "util.h"
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

