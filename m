Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbYH2FTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbYH2FTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 01:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYH2FTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 01:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbYH2FTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 01:19:35 -0400
Date: Thu, 28 Aug 2008 22:19:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: early_printk.c trivial sparse fixes
Message-Id: <20080828221916.eca064ae.akpm@linux-foundation.org>
In-Reply-To: <1219103789.17033.0.camel@brick>
References: <1219103789.17033.0.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 16:56:29 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -989,7 +989,7 @@ static int __init setup_early_printk(char *buf)
>  	return 0;
>  }
>  
> -void __init enable_debug_console(char *buf)
> +static void __init enable_debug_console(char *buf)
>  {
>  #ifdef DBGP_DEBUG
>  	struct console *old_early_console = NULL;

umm,

arch/x86/kernel/early_printk.c:993: warning: 'enable_debug_console' defined but not used

enable_debug_console() never has been used afaict.  If it was supposed
to be a __setup function then it'll need documentation in
Documentation/kernel-parameters.txt too, please.

