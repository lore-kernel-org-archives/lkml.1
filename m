Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0CJPah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:30:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47660 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0CJPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Em+J66uA+sEgOKw0BIOxRK+riWl+r0CR3tm1ooXjzinzJbFQqwLEjs/U4zTEuXLeXy
         DcJUcYjTP9xLu1Hwz/3wiySfvsTovVE68PZrWY0vDl6hMG2UYMB/daa1AYlqYqWPAnfd
         qGwUPFK8Qzol+wQQjSf3AGce9YLXeAv/5RP0E=
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B977815.4000703@ru.mvista.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
	 <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
	 <4B977815.4000703@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 10 Mar 2010 23:24:04 +0800
Message-ID: <1268234645.19976.1.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks very much for your careful review, will resend a new one later.

Regards,
	Wu Zhangjin

On Wed, 2010-03-10 at 13:44 +0300, Sergei Shtylyov wrote:
[...]
> > diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
> > index 3b6da33..b84cfda 100644
> > --- a/arch/mips/include/asm/stackframe.h
> > +++ b/arch/mips/include/asm/stackframe.h
> > @@ -121,6 +121,25 @@
> >  		.endm
> >  #else
> >  		.macro	get_saved_sp	/* Uniprocessor variation */
> > +#ifdef CONFIG_CPU_LOONGSON2F
> > +		/*
> > +		 * Clear BTB(branch target buffer), forbid RAS(row address
> > +		 * strobe)
> 
>    No spaces before the left paren...
> 
> >  to workaround the Out-of-oder Issue in Loongson2F
> > +		 * via it's diagnostic register.
> >   
> 
>    Only "its".
> 
> > +		 */
> > +		move k0, ra
> >   
> 
>    Operands misalined...
> 
> WBR, Sergei
> 
> 


