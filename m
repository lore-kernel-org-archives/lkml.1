Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042Ab0AMN3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0AMN3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341Ab0AMN3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab0AMN3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:29:02 -0500
Date: Wed, 13 Jan 2010 08:28:35 -0500 (EST)
From: John Kacur <jkacur@redhat.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: fweisbec@gmail.com, acme@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Message-ID: <110235132.210191263389315584.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <969870729.210151263389292546.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] perf: make cmd_to_page function compact
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Wenji Huang" <wenji.huang@oracle.com> wrote:

> Remove branch for is_perf_command
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  tools/perf/builtin-help.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 9f810b1..65e2691 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -314,8 +314,6 @@ static const char *cmd_to_page(const char
> *perf_cmd)
>  		return "perf";
>  	else if (!prefixcmp(perf_cmd, "perf"))
>  		return perf_cmd;
> -	else if (is_perf_command(perf_cmd))
> -		return prepend("perf-", perf_cmd);
>  	else
>  		return prepend("perf-", perf_cmd);
>  }
> -- 
> 1.5.6


Thanks, Wenji, I tested your change, and it works find.
Acked-by: John Kacur <jkacur@redhat.com>
