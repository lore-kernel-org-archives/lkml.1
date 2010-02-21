Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0BUOl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:41:27 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48038 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0BUOl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dxtCbj6+zk8Y5msHdXLH12XZgHdNe+lHbC4mGyuIMZ8Cqeh8zhygjMmGzPBna8qWq/
         mRYlEfyGtsPNY/RQTgQlB9MCg+bJFNiujo+UwM9k9pfB59CNctem4HOz7F174yyn9tyC
         eEsgA6SxXrPlrs5v2uOZkehDpxVal9eU7RLOE=
MIME-Version: 1.0
In-Reply-To: <20100221142813.GB21281@core2>
References: <20100221142303.GA3004@darkstar> <20100221142813.GB21281@core2>
Date: Sun, 21 Feb 2010 22:33:43 +0800
Message-ID: <a8e1da1002210633r7a4a8c5em93d908c829d1f4ff@mail.gmail.com>
Subject: Re: [PATCH -mm 03/17] sysctl extern cleanup - binfmts
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:28 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Feb 21, 2010 at 10:23:03PM +0800, Dave Young wrote:
>> --- linux-2.6.32.orig/include/linux/binfmts.h
>> +++ linux-2.6.32/include/linux/binfmts.h
>> @@ -20,6 +20,11 @@ struct pt_regs;
>>  #ifdef __KERNEL__
>>  #include <linux/list.h>
>>
>> +/* for sysctl */
>
> This comment is neither accurate nor needed. :^)

Thanks, sounds good, but the there's no other file use the three vars.

>
> In fact master sysctl table always was a big mess, so slight mess
> caused by extern declarations is fine.
>
>> +extern int core_uses_pid;
>> +extern char *core_pattern;
>> +extern unsigned int core_pipe_limit;
>



-- 
Regards
dave
