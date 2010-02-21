Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0BUO2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:28:22 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36258 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0BUO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kbqhHZZY2+gOhT+cGq8BPLbq6tc1bzmTTqmCOkDmOZZAPS9c5Az0k1BgvaAGiabV3y
         e0I5uZ3+CaG86gI/Uki0g9/hdb84X+Eal2Lis9RdEWM629Lv/uDOOQpUpHRdc9nktSta
         a3cCUkNe4uHHkYjoTYP06uV4FCzEby6M7fwMg=
Date: Sun, 21 Feb 2010 16:28:13 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 03/17] sysctl extern cleanup - binfmts
Message-ID: <20100221142813.GB21281@core2>
References: <20100221142303.GA3004@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221142303.GA3004@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:23:03PM +0800, Dave Young wrote:
> --- linux-2.6.32.orig/include/linux/binfmts.h
> +++ linux-2.6.32/include/linux/binfmts.h
> @@ -20,6 +20,11 @@ struct pt_regs;
>  #ifdef __KERNEL__
>  #include <linux/list.h>
>  
> +/* for sysctl */

This comment is neither accurate nor needed. :^)

In fact master sysctl table always was a big mess, so slight mess
caused by extern declarations is fine.

> +extern int core_uses_pid;
> +extern char *core_pattern;
> +extern unsigned int core_pipe_limit;
