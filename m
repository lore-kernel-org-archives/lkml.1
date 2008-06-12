Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYFLWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYFLWhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYFLWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:37:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41654 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbYFLWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:37:46 -0400
Message-ID: <4851A539.1050904@sgi.com>
Date: Thu, 12 Jun 2008 15:37:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223343.257409000@polaris-admin.engr.sgi.com> <20080612223343.392447000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080612223343.392447000@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore this patch.  I missed the quilt refresh
to pick up the latest version and will resend shortly.

Mike Travis wrote:
>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>    printk's to be directed to the serial console.
> 
> Based on linux-next
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> 
> ---
>  arch/x86/kernel/early_printk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.tip.orig/arch/x86/kernel/early_printk.c
> +++ linux-2.6.tip/arch/x86/kernel/early_printk.c
> @@ -193,7 +193,7 @@ static struct console simnow_console = {
>  };
>  
>  /* Direct interface for emergencies */
> -static struct console *early_console = &early_vga_console;
> +static struct console *early_console = &early_serial_console;
>  static int early_console_initialized;
>  
>  void early_printk(const char *fmt, ...)
> 

