Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934853Ab0BZBKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:10:31 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58988 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934832Ab0BZBKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:10:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=t/e2dzcNdJglpaNpxgTBbwAHLILC8cmMdSBGRZLS9SH9jpzKnUTfp5ZcA6LoUcYDxo
         abCHsgjDnFEF5sTbySQk7/zCIbXfQ0rXRk0uuFzEcMecvt1NrdP41FtRETfmI30VW/ex
         0Ak9EwFphlE1pdcOJSM097BHZkTMyIm2GZxYo=
MIME-Version: 1.0
In-Reply-To: <20100225185320.GA3305@core2>
References: <20100225153911.GA2661@darkstar> <20100225185320.GA3305@core2>
Date: Fri, 26 Feb 2010 09:10:28 +0800
Message-ID: <a8e1da1002251710l7edb3a49nf3721d0c729b30a5@mail.gmail.com>
Subject: Re: [PATCH 02/07] kernel.h panic cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 2:53 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Feb 25, 2010 at 11:39:11PM +0800, Dave Young wrote:
>> Cleanup kernel.h panic related stuff, move to linux/panic.h
>>
>> Due to lots of files need it, include them in kernel.h just for convinience
>> It can be thought as the first step of further cleanup.
>
> NAK, tainted stuff belongs to separate place.

Then where should they go?

>
>> --- linux-2.6.orig/include/linux/kernel.h
>> +++ linux-2.6/include/linux/kernel.h
>> -extern const char *print_tainted(void);
>> -extern void add_taint(unsigned flag);
>> -extern int test_taint(unsigned flag);
>> -extern unsigned long get_taint(void);
>



-- 
Regards
dave
