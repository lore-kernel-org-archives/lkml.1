Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867Ab0BZBOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:14:36 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45127 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934840Ab0BZBOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sNyDyWbOttNaldtSC+MrsdiqZb5yvBEYyPbK8pPe53rk77IJ4gxCOgaNBufOR7+GFb
         GuWoyXhbQbaWOGXWMWmpiZOxmNaMHq4PTCox+vZRoBcQxyMk1AJBmfX7patqSifo90mc
         0sd8phGvlGguDk6/is3NoEy27VYcKYbC42+5k=
MIME-Version: 1.0
In-Reply-To: <20100225185515.GB3305@core2>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
Date: Fri, 26 Feb 2010 09:14:30 +0800
Message-ID: <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 2:55 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Feb 25, 2010 at 11:53:59PM +0800, Dave Young wrote:
>> Cleanup kernel.h string related stuff, move to linux/string.h
>
> Ick.
>
> That's not where they're in userspace headers.

Yeah, same question, then where should they go? I think string.h is fine.

Thanks.

>
>> --- linux-2.6.orig/include/linux/kernel.h
>> +++ linux-2.6/include/linux/kernel.h
>> @@ -136,34 +137,6 @@ NORET_TYPE void do_exit(long error_code)
>>       ATTRIB_NORET;
>>  NORET_TYPE void complete_and_exit(struct completion *, long)
>>       ATTRIB_NORET;
>> -extern unsigned long simple_strtoul(const char *,char **,unsigned int);
>> -extern long simple_strtol(const char *,char **,unsigned int);
>> -extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
>> -extern long long simple_strtoll(const char *,char **,unsigned int);
>> -extern int strict_strtoul(const char *, unsigned int, unsigned long *);
>> -extern int strict_strtol(const char *, unsigned int, long *);
>> -extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
>> -extern int strict_strtoll(const char *, unsigned int, long long *);
>> -extern int sprintf(char * buf, const char * fmt, ...)
>> -     __attribute__ ((format (printf, 2, 3)));
>> -extern int vsprintf(char *buf, const char *, va_list)
>> -     __attribute__ ((format (printf, 2, 0)));
>> -extern int snprintf(char * buf, size_t size, const char * fmt, ...)
>> -     __attribute__ ((format (printf, 3, 4)));
>> -extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>> -     __attribute__ ((format (printf, 3, 0)));
>> -extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
>> -     __attribute__ ((format (printf, 3, 4)));
>> -extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
>> -     __attribute__ ((format (printf, 3, 0)));
>> -extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
>> -     __attribute__ ((format (printf, 2, 3)));
>> -extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
>> -
>> -extern int sscanf(const char *, const char *, ...)
>> -     __attribute__ ((format (scanf, 2, 3)));
>> -extern int vsscanf(const char *, const char *, va_list)
>> -     __attribute__ ((format (scanf, 2, 0)));
>



-- 
Regards
dave
