Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZKCPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZKCPqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZKCPqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:46:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZKCPqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:46:46 -0500
Message-ID: <4AF0504D.3020406@redhat.com>
Date: Tue, 03 Nov 2009 10:46:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] perf probe: Annotate variable initialization
References: <1257254947-16789-1-git-send-email-acme@infradead.org>
In-Reply-To: <1257254947-16789-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo<acme@redhat.com>
>
>      cc1: warnings being treated as errors
>      builtin-probe.c: In function ‘parse_probe_event’:
>      builtin-probe.c:72: warning: ‘nc’ is used uninitialized in this function
>
> Cc: Masami Hiramatsu<mhiramat@redhat.com>
> Signed-off-by: Arnaldo Carvalho de Melo<acme@redhat.com>

Oops, thank you!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>   tools/perf/builtin-probe.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index a99a366..8124523 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -69,7 +69,7 @@ static struct {
>   static void parse_probe_point(char *arg, struct probe_point *pp)
>   {
>   	char *ptr, *tmp;
> -	char c, nc;
> +	char c, nc = 0;
>   	/*
>   	 *<Syntax>
>   	* perf probe SRC:LN

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

