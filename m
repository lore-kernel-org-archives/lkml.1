Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbZHEKlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbZHEKlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbZHEKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:41:34 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:64780 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbZHEKle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:41:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf report: Make --sort comm,dso,symbol the default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@redhat.com
In-Reply-To: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
References: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 12:41:18 +0200
Message-Id: <1249468878.7924.251.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 13:25 +0300, Pekka Enberg wrote:
> If you're doing performance testing, you're interested in the symbols
> anyway so lets make "--sort comm,dso,symbol" the default sort option.

Seems sensible,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  tools/perf/builtin-report.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index b20a4b6..181cef1 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -31,7 +31,7 @@
>  static char		const *input_name = "perf.data";
>  static char		*vmlinux = NULL;
>  
> -static char		default_sort_order[] = "comm,dso";
> +static char		default_sort_order[] = "comm,dso,symbol";
>  static char		*sort_order = default_sort_order;
>  static char		*dso_list_str, *comm_list_str, *sym_list_str,
>  			*col_width_list_str;
> @@ -1423,7 +1423,7 @@ print_entries:
>  	if (sort_order == default_sort_order &&
>  			parent_pattern == default_parent_pattern) {
>  		fprintf(fp, "#\n");
> -		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
> +		fprintf(fp, "# (For an high level overview, try: perf report --sort comm,dso)\n");
>  		fprintf(fp, "#\n");
>  	}
>  	fprintf(fp, "\n");

