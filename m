Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYK0K4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYK0K4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYK0KhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:37:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52908 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbYK0KhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:37:04 -0500
Message-Id: <1227782223.31044.1287040549@webmail.messagingengine.com>
X-Sasl-Enc: WmKS5EuMc5ED+z3VP1a5ScRf7xt7zSt4hCq0DL52Qw2i 1227782223
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
Subject: Re: [PATCH 1/5] x86: entry_64.S - use ENTRY to define child_rip
In-Reply-To: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
Date: Thu, 27 Nov 2008 11:37:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008 22:17:00 +0300, gorcunov@gmail.com said:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> child_rip is called not by its name but indirectly
> rather so make it global and aligned.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 64688db..098ba0b 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1322,7 +1322,7 @@ ENTRY(kernel_thread)
>  	CFI_ENDPROC
>  END(kernel_thread)
>  
> -child_rip:
> +ENTRY(child_rip)
>  	pushq $0		# fake return address
>  	CFI_STARTPROC
>  	/*

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

> 1.6.0.4.603.gbc9c0
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

