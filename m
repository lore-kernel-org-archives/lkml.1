Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYGIAyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYGIAyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 20:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYGIAyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 20:54:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55413 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYGIAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 20:54:32 -0400
Subject: Re: [PATCH] kernel/printk.c: Made printk_recursion_bug_msg static.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Daniel Guilak <guilak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       daniel@danielguilak.com
In-Reply-To: <1215554526.10304.10.camel@dguilak-desk>
References: <1215554526.10304.10.camel@dguilak-desk>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 17:54:31 -0700
Message-Id: <1215564871.3071.36.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 15:02 -0700, Daniel Guilak wrote:
> Signed-off-by: Daniel Guilak <daniel@danielguilak.com>

Acked-by: Josh Triplett <josh@kernel.org>

> ---
>  kernel/printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 8fb01c3..e2129e8 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -666,7 +666,7 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
>  	return retval;
>  }
> 
> -const char printk_recursion_bug_msg [] =
> +static const char printk_recursion_bug_msg [] =
>  			KERN_CRIT "BUG: recent printk recursion!\n";
>  static int printk_recursion_bug;
> 

