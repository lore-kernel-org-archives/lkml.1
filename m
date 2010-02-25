Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab0BYSzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:55:24 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49362 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0BYSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMePx6lkLEmqzle8xM3mUroselUPh8odPbUOTzfRvrkBRN7NGlvuA5Zcwls1pXL2Rg
         uLrxpvQiqR53KVpN+q75lJcw+h9nvJ/LcVQfsEaMEzzzPeCixF9MbkLg8rTURnJq1Qan
         FLPjc8h/DTWdtyaaQqhf0xfDqPbyflrt8pmGY=
Date: Thu, 25 Feb 2010 20:55:15 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/07] kernel.h string cleanup
Message-ID: <20100225185515.GB3305@core2>
References: <20100225155359.GA2722@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225155359.GA2722@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:53:59PM +0800, Dave Young wrote:
> Cleanup kernel.h string related stuff, move to linux/string.h

Ick.

That's not where they're in userspace headers.

> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -136,34 +137,6 @@ NORET_TYPE void do_exit(long error_code)
>  	ATTRIB_NORET;
>  NORET_TYPE void complete_and_exit(struct completion *, long)
>  	ATTRIB_NORET;
> -extern unsigned long simple_strtoul(const char *,char **,unsigned int);
> -extern long simple_strtol(const char *,char **,unsigned int);
> -extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
> -extern long long simple_strtoll(const char *,char **,unsigned int);
> -extern int strict_strtoul(const char *, unsigned int, unsigned long *);
> -extern int strict_strtol(const char *, unsigned int, long *);
> -extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
> -extern int strict_strtoll(const char *, unsigned int, long long *);
> -extern int sprintf(char * buf, const char * fmt, ...)
> -	__attribute__ ((format (printf, 2, 3)));
> -extern int vsprintf(char *buf, const char *, va_list)
> -	__attribute__ ((format (printf, 2, 0)));
> -extern int snprintf(char * buf, size_t size, const char * fmt, ...)
> -	__attribute__ ((format (printf, 3, 4)));
> -extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> -	__attribute__ ((format (printf, 3, 0)));
> -extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
> -	__attribute__ ((format (printf, 3, 4)));
> -extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
> -	__attribute__ ((format (printf, 3, 0)));
> -extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
> -	__attribute__ ((format (printf, 2, 3)));
> -extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
> -
> -extern int sscanf(const char *, const char *, ...)
> -	__attribute__ ((format (scanf, 2, 3)));
> -extern int vsscanf(const char *, const char *, va_list)
> -	__attribute__ ((format (scanf, 2, 0)));
