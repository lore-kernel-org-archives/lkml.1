Return-Path: <linux-kernel-owner+w=401wt.eu-S1751005AbZIZF7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005AbZIZF7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 01:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZIZF7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 01:59:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34320 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZIZF7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 01:59:03 -0400
Message-ID: <4ABDAD8B.2040307@gmail.com>
Date: Sat, 26 Sep 2009 07:58:35 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] perf top: Add poll_idle to the skip list
References: <20090925220239.GA5488@ghostprotocols.net>
In-Reply-To: <20090925220239.GA5488@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 26 Sep 2009 07:58:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo a écrit :
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-top.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index a92e82b..15c221e 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -779,6 +779,7 @@ static const char *skip_symbols[] = {
>  	"exit_idle",
>  	"mwait_idle",
>  	"mwait_idle_with_hints",
> +	"poll_idle",
>  	"ppc64_runlatch_off",
>  	"pseries_dedicated_idle_sleep",
>  	NULL

I was about to submit same patch :)

Thanks

