Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZLMWi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZLMWi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZLMWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:38:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:44503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZLMWi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:38:27 -0500
Date: Sun, 13 Dec 2009 23:38:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ataflop: Killl warning about unused variable flags
In-Reply-To: <alpine.DEB.2.00.0912132006430.19895@ayla.of.borg>
Message-ID: <alpine.LNX.2.00.0912132337400.3755@pobox.suse.cz>
References: <alpine.DEB.2.00.0912132006430.19895@ayla.of.borg>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009, Geert Uytterhoeven wrote:

> After commit e0c0978699a83f26f2341f7eedc1463b79e31aff ("ataflop: remove
> buggy/commented-out IRQ disable from do_fd_request()") the `flags' variable
> became unused:
> 
> drivers/block/ataflop.c:1473: warning: unused variable 'flags'
> 
> Hence remove it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/block/ataflop.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> index a5af1d6..e35cf59 100644
> --- a/drivers/block/ataflop.c
> +++ b/drivers/block/ataflop.c
> @@ -1470,8 +1470,6 @@ repeat:
>  
>  void do_fd_request(struct request_queue * q)
>  {
> - 	unsigned long flags;
> -

Ah, I forogt to remove this one, thanks for noticing. I have queued your 
patch in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
