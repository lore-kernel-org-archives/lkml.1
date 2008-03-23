Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYCWJMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYCWJMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761338AbYCWI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:59:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:36181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbYCWI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qqON8MIwCkzF22jhcpIBkT7H8r1gj//X8moCuBR7uHafU+SLvykWJAW6CYQ/3Xyj8V7RZRS/ng/I+g0REJiROsLi51T+/QECnfSAMgazSzSD9m/iO+ykirKAyZqNES3g7xwp0IXZ4JBSvO/Uf1zrPVzvKEpEtKWyWdEIHCuBPr0=
Date: Sun, 23 Mar 2008 11:57:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 120/148] include/asm-x86/suspend_32.h: checkpatch
	cleanups - formatting only
Message-ID: <20080323085726.GA4216@martell.zuzino.mipt.ru>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-121-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206259443-13210-121-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 01:03:35AM -0700, Joe Perches wrote:
> --- a/include/asm-x86/suspend_32.h
> +++ b/include/asm-x86/suspend_32.h
> @@ -32,11 +32,11 @@ extern unsigned long saved_edi;
>  static inline void acpi_save_register_state(unsigned long return_point)
>  {
>  	saved_eip = return_point;
> -	asm volatile ("movl %%esp,%0" : "=m" (saved_esp));
> -	asm volatile ("movl %%ebp,%0" : "=m" (saved_ebp));
> -	asm volatile ("movl %%ebx,%0" : "=m" (saved_ebx));
> -	asm volatile ("movl %%edi,%0" : "=m" (saved_edi));
> -	asm volatile ("movl %%esi,%0" : "=m" (saved_esi));
> +	asm volatile("movl %%esp,%0" : "=m" (saved_esp));
> +	asm volatile("movl %%ebp,%0" : "=m" (saved_ebp));
> +	asm volatile("movl %%ebx,%0" : "=m" (saved_ebx));
> +	asm volatile("movl %%edi,%0" : "=m" (saved_edi));
> +	asm volatile("movl %%esi,%0" : "=m" (saved_esi));

Since when "volatile" became a function?

