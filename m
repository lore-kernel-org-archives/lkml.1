Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJYSPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJYSPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYJYSPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:15:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59669 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYJYSPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:15:04 -0400
Message-ID: <4903621B.9040101@redhat.com>
Date: Sat, 25 Oct 2008 14:14:51 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Define DIE_OOPS in asm-generic
References: <1224928160-19147-1-git-send-email-jonas.bonn@gmail.com>
In-Reply-To: <1224928160-19147-1-git-send-email-jonas.bonn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn wrote:
> DIE_OOPS is now used in the generic trace handling code so it needs to
> be defined for all architectures.  Define it in asm-generic so that it's
> available to all by default and doesn't cause build errors for
> architectures that rely on the generic implementation.
>
> Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
> ---
>  include/asm-generic/kdebug.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>   

This will obsolete my other patch. (the one making the nmi handler weak)

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> diff --git a/include/asm-generic/kdebug.h b/include/asm-generic/kdebug.h
> index 2b799c9..11e57b6 100644
> --- a/include/asm-generic/kdebug.h
> +++ b/include/asm-generic/kdebug.h
> @@ -3,6 +3,7 @@
>  
>  enum die_val {
>  	DIE_UNUSED,
> +	DIE_OOPS=1
>  };
>  
>  #endif /* _ASM_GENERIC_KDEBUG_H */
>   

