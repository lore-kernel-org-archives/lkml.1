Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYAQC7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYAQC7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYAQC7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:59:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:21411 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYAQC7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:59:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bGYoNnnwUuEG3+lvz1Cek+IM5qn0AoiSCDsXN8VHAGi9LmI+NbS8oEI9moaaRli5J1woEMR6WlzZE09mFghqp+oPNqSlhlr8QConNGxHb2Cs12kFSCdctFqKbyCM78/m1L014y9rYmBADI3GGLSzr0fLlO5sW/TmL3ZKHW7y2JQ=
Subject: Re: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080116222706.8074A14EE3@wotan.suse.de>
References: <200801161127.268350000@suse.de>
	 <20080116222706.8074A14EE3@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 18:58:58 -0800
Message-Id: <1200538738.17967.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 23:27 +0100, Andi Kleen wrote:
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/fault_32.c |    2 +-

Could use exactly the same in fault_64.c

>  #ifdef CONFIG_X86_32
> -			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
> +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
>  #else
>  			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
>  #endif

With the ongoing unification work, it would be nice if we could come
up with a way to unify printks like this.  Anyone have any bright ideas
on a format that will keep the current alignment on 32 and 64 bit with
the same syntax, or will these tiny ifdefs keep sprouting?

Harvey

