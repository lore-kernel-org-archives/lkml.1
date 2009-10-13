Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZJMBXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZJMBXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZJMBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:23:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:14355 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbZJMBXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:23:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,548,1249282800"; 
   d="scan'208";a="198154483"
Date: Tue, 13 Oct 2009 09:22:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] page-types: trivial typo fixes
Message-ID: <20091013012254.GA7345@localhost>
References: <1255380694-4122-1-git-send-email-tt.rantala@gmail.com> <1255380694-4122-2-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255380694-4122-2-git-send-email-tt.rantala@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:51:34AM +0800, Tommi Rantala wrote:
> Trivial typo fixes.

Good catch, thanks!

Fengguang

> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
> ---
>  Documentation/vm/page-types.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
> index 16fb478..d6d21c2 100644
> --- a/Documentation/vm/page-types.c
> +++ b/Documentation/vm/page-types.c
> @@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t flags)
>  		present = (flags >> i) & 1;
>  		if (!page_flag_names[i]) {
>  			if (present)
> -				fatal("unkown flag bit %d\n", i);
> +				fatal("unknown flag bit %d\n", i);
>  			continue;
>  		}
>  		buf[j++] = present ? page_flag_names[i][0] : '_';
> @@ -682,7 +682,7 @@ static void usage(void)
>  #endif
>  "            -l|--list                 Show page details in ranges\n"
>  "            -L|--list-each            Show page details one by one\n"
> -"            -N|--no-summary           Don't show summay info\n"
> +"            -N|--no-summary           Don't show summary info\n"
>  "            -X|--hwpoison             hwpoison pages\n"
>  "            -x|--unpoison             unpoison pages\n"
>  "            -h|--help                 Show this usage message\n"
> -- 
> 1.5.6.5
