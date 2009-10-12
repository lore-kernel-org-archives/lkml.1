Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZJLLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZJLLTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZJLLTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZJLLTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:19:51 -0400
Date: Mon, 12 Oct 2009 13:19:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - enabling "__cold" functions
Message-ID: <20091012111917.GA6934@jolsa.lab.eng.brq.redhat.com>
References: <1255104899-27784-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255104899-27784-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any feedback on this one?

thanks,
jirka

On Fri, Oct 09, 2009 at 06:14:59PM +0200, jolsa@redhat.com wrote:
> Based on the commit:
> 
> a586df06 "x86: Support __attribute__((__cold__)) in gcc 4.3"
> 
> some of the functions goes to the ".text.unlikely" section.
> 
> Looks like there's not many of them (I found printk, panic,
> __ssb_dma_not_implemented, fat_fs_error), but still worth
> to include I think.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  scripts/recordmcount.pl |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 090d300..bfb8b2c 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -119,6 +119,7 @@ my %text_sections = (
>       ".sched.text" => 1,
>       ".spinlock.text" => 1,
>       ".irqentry.text" => 1,
> +     ".text.unlikely" => 1,
>  );
>  
>  $objdump = "objdump" if ((length $objdump) == 0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
