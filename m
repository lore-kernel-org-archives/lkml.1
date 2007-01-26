Return-Path: <linux-kernel-owner+w=401wt.eu-S1161193AbXAZTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161193AbXAZTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXAZTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:16:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:27678 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161193AbXAZTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=C92gF+WZv/USG32XZURcXthf6Y+W4dzd4mMX7+p2T5EJHTuMsRtKd8Yz38vWluOBcX2+g815qch6tPxdOvh+TrY9p9++6efag2WQpfkTNF2fnMrMAXhT54OpvI2/velBKOtZdZXwMNvARDwEjvkvs6hY03OrGs7LQ03tMwrbUrU=
Date: Fri, 26 Jan 2007 22:16:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove final vestiges of CONFIG_UNWIND_INFO.
Message-ID: <20070126191644.GA5534@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0701261301590.27767@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701261301590.27767@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:06:39PM -0500, Robert P. J. Day wrote:
>   Remove the sole remaining reference to the apparently dead config
> variable CONFIG_UNWIND_INFO.

Regardless of unwinder future, patch doesn't update defconfigs all over
the tree.

> --- a/include/asm-i386/dwarf2.h
> +++ b/include/asm-i386/dwarf2.h
> @@ -12,30 +12,6 @@
>     away for older version.
>   */
>
> -#ifdef CONFIG_UNWIND_INFO
> -
> -#define CFI_STARTPROC .cfi_startproc
> -#define CFI_ENDPROC .cfi_endproc
> -#define CFI_DEF_CFA .cfi_def_cfa
> -#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
> -#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
> -#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
> -#define CFI_OFFSET .cfi_offset
> -#define CFI_REL_OFFSET .cfi_rel_offset
> -#define CFI_REGISTER .cfi_register
> -#define CFI_RESTORE .cfi_restore
> -#define CFI_REMEMBER_STATE .cfi_remember_state
> -#define CFI_RESTORE_STATE .cfi_restore_state
> -#define CFI_UNDEFINED .cfi_undefined
> -
> -#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
> -#define CFI_SIGNAL_FRAME .cfi_signal_frame
> -#else
> -#define CFI_SIGNAL_FRAME
> -#endif
> -
> -#else
> -
>  /* Due to the structure of pre-exisiting code, don't use assembler line
>     comment character # to ignore the arguments. Instead, use a dummy macro. */
>  .macro ignore a=0, b=0, c=0, d=0
> @@ -57,5 +33,3 @@
>  #define CFI_SIGNAL_FRAME ignore
>
>  #endif
> -
> -#endif

