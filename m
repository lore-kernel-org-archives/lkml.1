Return-Path: <linux-kernel-owner+w=401wt.eu-S965869AbXDIPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbXDIPto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXDIPto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:49:44 -0400
Received: from gw.goop.org ([64.81.55.164]:37020 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965869AbXDIPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:49:43 -0400
Message-ID: <461A604D.7050903@goop.org>
Date: Mon, 09 Apr 2007 08:48:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH 1/2] Clean up asm-x86_64/bugs.h
References: <4617D339.3080801@goop.org> <20070409084557.28748317.randy.dunlap@oracle.com>
In-Reply-To: <20070409084557.28748317.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 07 Apr 2007 10:22:01 -0700 Jeremy Fitzhardinge wrote:
>
>   
>> Most of asm-x86_64/bugs.h is code which should be in a C file, so put it there.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Cc: Andi Kleen <ak@suse.de>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> ---
>>  arch/x86_64/kernel/Makefile      |    3 ++-
>>  arch/x86_64/kernel/bugs.c        |   28 ++++++++++++++++++++++++++++
>>  include/asm-x86_64/alternative.h |    1 +
>>  include/asm-x86_64/bugs.h        |   30 ++++--------------------------
>>  4 files changed, 35 insertions(+), 27 deletions(-)
>>
>> ===================================================================
>> --- /dev/null
>> +++ b/arch/x86_64/kernel/bugs.c
>> @@ -0,0 +1,28 @@
>> +/*
>> + *  arch/x86_64/kernel/bugs.c
>> + *
>> + *  Copyright (C) 1994  Linus Torvalds
>> + *  Copyright (C) 2000  SuSE
>> + *
>> + * This is included by init/main.c to check for architecture-dependent bugs.
>>     
>
> drop comment.
>
> Are you going to tackle asm-i386/bugs.h also?

Yes, I'd already sent it out.  This was just the response to "please
make them consistent".

    J
