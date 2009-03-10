Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZCJNVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZCJNVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZCJNU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:20:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:45413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZCJNUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:20:55 -0400
Date: Tue, 10 Mar 2009 06:21:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Ozan =?UTF-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable
 machines with plenty memory.
Message-ID: <20090310062134.704d2c7e@infradead.org>
In-Reply-To: <1236677828.25234.9.camel@laptop>
References: <49B254C6.8010507@pardus.org.tr>
	<20090307193026.GA2165@x200.localdomain>
	<49B2CE44.4060305@pardus.org.tr>
	<87r617ojfi.fsf@firstfloor.org>
	<1236606168.8389.512.camel@laptop>
	<20090309191504.GB11935@one.firstfloor.org>
	<1236677828.25234.9.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 10:37:08 +0100
Peter Zijlstra <peterz@infradead.org> wrote:
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 34ef5c7..e759107 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -713,13 +713,19 @@ void __init lowmem_pfn_init(void)
>  	"only %luMB highmem pages available, ignoring highmem size
> of %luMB!\n" 
>  #define MSG_HIGHMEM_TRIMMED \
> -	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled
> kernel!\n"
> +	"Warning: only 4GB will be used. Use a %s kernel!\n"
> +
> +#define MSG_LM_TRIMMED \
> +	"Warning: instead of using a 32bit %s kernel, Use a 64bit
> kernel!\n" +

I would like to avoid the prefix "Warning:" for something like this ;-)

lets keep that prefix for Real Warnings(tm) instead please.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
