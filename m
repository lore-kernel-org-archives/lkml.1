Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYK0K4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYK0K4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYK0KiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:38:00 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48768 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898AbYK0Kh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:37:59 -0500
Message-Id: <1227782278.31536.1287041953@webmail.messagingengine.com>
X-Sasl-Enc: SYLnKzDV4gxMcGwpzKVgqls+2SfC34U6MLt+KURtHfda 1227782278
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
Subject: Re: [PATCH 3/5] x86: entry_64.S - use X86_EFLAGS_IF instead of
 hardcoded number
In-Reply-To: <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
Date: Thu, 27 Nov 2008 11:37:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008 22:17:02 +0300, gorcunov@gmail.com said:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Impact: cleanup
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>


>  arch/x86/kernel/entry_64.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 7b52b0f..c409f73 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -199,7 +199,7 @@ ENTRY(native_usergs_sysret64)
>  	pushq %rax /* rsp */
>  	CFI_ADJUST_CFA_OFFSET	8
>  	CFI_REL_OFFSET	rsp,0
> -	pushq $(1<<9) /* eflags - interrupts on */
> +	pushq $X86_EFLAGS_IF /* eflags - interrupts on */
>  	CFI_ADJUST_CFA_OFFSET	8
>  	/*CFI_REL_OFFSET	rflags,0*/
>  	pushq $__KERNEL_CS /* cs */
> 
> 1.6.0.4.603.gbc9c0
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

