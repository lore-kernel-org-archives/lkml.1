Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0BVBvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:51:20 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35941 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BVBvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PNtWu0BY6Cdz0O4FoO8yoBDkFTJP28mq4EY1J1QVk7S0C5awkPIpeons2ne0cw8kR7
         jHmKx7l7Yl37ic9eV6NgpyukC9xnfhydXNSMv/u3GB+Eeu8Z5KbsX2HZC4uUO2WxR8g/
         jR61ulNJ3NCPmmvPaV0RNmw8aWIAJIMffymeQ=
Date: Mon, 22 Feb 2010 02:51:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 05/12] perf trace/scripting: remove check-perf-trace
	from listed scripts
Message-ID: <20100222015111.GB8791@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:27:56AM -0600, Tom Zanussi wrote:
> The check-perf-trace script only checks Perl functionality, and
> doesn't really need to be listed as as user script anyway.
> 
> This only removes the '-report' shell script, so although it doesn't
> appear in the listing, the '-record' shell script and the check perf
> trace perl script itself is still available and can still be run
> manually as such:
> 
> $ libexec/perf-core/scripts/perl/bin/check-perf-trace-record
> $ perf trace -s libexec/perf-core/scripts/perl/check-perf-trace.pl
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> ---
>  .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +------
>  .../perf/scripts/perl/bin/check-perf-trace-report  |    6 ------
>  2 files changed, 1 insertions(+), 12 deletions(-)
>  delete mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report
> 
> diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
> index c7ec5de..f439cc3 100644
> --- a/tools/perf/scripts/perl/bin/check-perf-trace-record
> +++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
> @@ -1,7 +1,2 @@
>  #!/bin/bash
> -perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry
> -
> -
> -
> -
> -
> +perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry -e kmem:kmalloc



Looks like kmem:kmalloc has been appended twice incidentally there.
No problem, I'll remove it.

Thanks.

