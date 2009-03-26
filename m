Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZCZUDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZCZUDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZCZUDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:03:46 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53112 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZCZUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=punq8UjyJ2NnRxd5hDAb8Nkn38fNxiWxMYi2Gq6W1YqddUlJuk/wU++IQMdAo9Q5z2
         VoewvBX6LTFqAA8zkYaLSuqZk6Lm60uCSxVjE2Io8QTdbf9+J9ZDiHBeIi5YaknruOQM
         48kHnv73drKBk6hb1DUbO64dexXwh8dqr5+7g=
Date: Thu, 26 Mar 2009 22:03:38 +0200
From: Pekka Paalanen <pq@iki.fi>
To: mingo@redhat.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, pq@iki.fi,
       stuart@freedesktop.org, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86: mmiotrace: quieten spurious warning
 message
Message-ID: <20090326220338.1b4ad12e@daedalus.pq.iki.fi>
In-Reply-To: <tip-afcfe024aebd74b0984a41af9a34e009cf5badaf@git.kernel.org>
References: <tip-afcfe024aebd74b0984a41af9a34e009cf5badaf@git.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 20:45:45 GMT
Stuart Bennett <stuart@freedesktop.org> wrote:

> Commit-ID:  afcfe024aebd74b0984a41af9a34e009cf5badaf
> Gitweb:     http://git.kernel.org/tip/afcfe024aebd74b0984a41af9a34e009cf5badaf
> Author:     "Stuart Bennett" <stuart@freedesktop.org>
> AuthorDate: Wed, 11 Mar 2009 20:29:45 +0000
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 11 Mar 2009 21:41:58 +0100
> 
> x86: mmiotrace: quieten spurious warning message
> 
> This message was being incorrectly emitted when using gdb,
> so compile it out by default for now; there will be a
> better fix in v2.6.30.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
> Acked-by: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 

Guys,

wasn't this supposed to go into 2.6.29?
I don't see this in Linus' master, was it too late?

> 
> ---
>  arch/x86/mm/kmmio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> index 6a518dd..4f115e0 100644
> --- a/arch/x86/mm/kmmio.c
> +++ b/arch/x86/mm/kmmio.c
> @@ -310,7 +310,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
>  	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
>  
>  	if (!ctx->active) {
> -		pr_warning("kmmio: spurious debug trap on CPU %d.\n",
> +		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
>  							smp_processor_id());
>  		goto out;
>  	}
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
