Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZLVDOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZLVDOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 22:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZLVDOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 22:14:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZLVDOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 22:14:20 -0500
Message-ID: <4B30397E.5000209@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 11:14:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wenji Huang <wenji.huang@oracle.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] perf: fix typo in builtin-kmem.c
References: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
In-Reply-To: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenji Huang wrote:
> Replace bytes_req with bytes_alloc.
> 

Thanks!

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  tools/perf/builtin-kmem.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index fc21ad7..7ceb741 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -137,7 +137,7 @@ static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
>  	if (data && data->ptr == ptr) {
>  		data->hit++;
>  		data->bytes_req += bytes_req;
> -		data->bytes_alloc += bytes_req;
> +		data->bytes_alloc += bytes_alloc;
>  	} else {
>  		data = malloc(sizeof(*data));
>  		if (!data)
> @@ -177,7 +177,7 @@ static void insert_caller_stat(unsigned long call_site,
>  	if (data && data->call_site == call_site) {
>  		data->hit++;
>  		data->bytes_req += bytes_req;
> -		data->bytes_alloc += bytes_req;
> +		data->bytes_alloc += bytes_alloc;
>  	} else {
>  		data = malloc(sizeof(*data));
>  		if (!data)
