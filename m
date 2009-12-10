Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZLJVSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZLJVSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761715AbZLJVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:18:03 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:44502 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761711AbZLJVR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:17:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ibC1V5QEdkwk41a/PrB6j7upKLGIHDRZ4tyMHxdpBeEiJjXrrQsOWTFYvXIVpKiubr
         c1m9kmFxH7nE3egL1hW6bZtvnLkuORxnVMZ8c0ayEGq95uTHHr2rgZ2L8HqamBlGJvUP
         knVAy/19IGoCjqZCm9qEmqws5vegYzrCjR8os=
MIME-Version: 1.0
In-Reply-To: <200912102210.12124.arnd@arndb.de>
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com> 
	<200912071614.46166.arnd@arndb.de> <200912102210.12124.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Dec 2009 16:17:44 -0500
Message-ID: <8bd0f97a0912101317v8143e67w9e2f1224111ac0d7@mail.gmail.com>
Subject: Re: What's in asm-generic.git
To: Arnd Bergmann <arnd@arndb.de>
Cc: liqin.chen@sunplusct.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/10 Arnd Bergmann:
> On Monday 07 December 2009, Arnd Bergmann wrote:
>> On Monday 07 December 2009, liqin.chen@sunplusct.com wrote:
>> > Arnd Bergmann <arnd@arndb.de> 写于 2009-12-04 03:14:08:
>> >
>> > Maybe you can add a __NR_set_thread_area define in asm-generic/unsitd.h
>> > for tls used.
>>
>> Yes, good point. I'll update the syscall list with this, and also check if more
>> syscalls have been addded.
>
> I have found now that sys_accept4 was missing. sys_set_thread_area however
> is only defined on x86 and mips. Since you don't currently implement this
> on score, maybe it would be more appropriate to handle it like the other
> architectures do, rather than adding it to asm-generic/unistd.h?

isnt the point of asm-generic/unistd.h to collect all common syscalls
?  if there's syscalls that ideally should be handled by everyone but
currently doesnt, then it's easy to define it in the header but have
the actual entry.S leave it as a hole ...

or maybe i'm missing what's going on
-mike
