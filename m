Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZLKMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZLKMyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZLKMx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:53:57 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50953 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZLKMx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iasiJmENLMnDXTNRNCMTPX+VoAjcGWnRFiYX4nyR22g8f0Ygt6UII+3oTu1sUuTead
         Vfqvp1AV3rN/GTRaeEYYN4NSxV8z4h9AcNMi3JsvN3HbPJ2KNUxC7UbjdTK9qSEzHIDk
         DxeWILidnPgu0uPTGhvWekIHT6zWIoWyyG1io=
MIME-Version: 1.0
In-Reply-To: <200912102225.05280.arnd@arndb.de>
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com>
	 <200912102210.12124.arnd@arndb.de>
	 <8bd0f97a0912101317v8143e67w9e2f1224111ac0d7@mail.gmail.com>
	 <200912102225.05280.arnd@arndb.de>
Date: Fri, 11 Dec 2009 13:54:01 +0100
X-Google-Sender-Auth: 3c572297862ec66b
Message-ID: <10f740e80912110454u172fc2cfye30da6ca0e0f0af0@mail.gmail.com>
Subject: Re: What's in asm-generic.git
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, liqin.chen@sunplusct.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 22:25, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 10 December 2009, Mike Frysinger wrote:
>> > I have found now that sys_accept4 was missing. sys_set_thread_area however
>> > is only defined on x86 and mips. Since you don't currently implement this
>> > on score, maybe it would be more appropriate to handle it like the other
>> > architectures do, rather than adding it to asm-generic/unistd.h?
>>
>> isnt the point of asm-generic/unistd.h to collect all common syscalls
>> ?  if there's syscalls that ideally should be handled by everyone but
>> currently doesnt, then it's easy to define it in the header but have
>> the actual entry.S leave it as a hole ...
>
> Well, sys_thread_area is not a common syscall but rather an exception.
> I haven't looked at how glibc does implents TLS on different architectures,
> but I think this is commonly done purely in user space without the
> need for a syscall.

10+ architectures already have sys_[sg]et_thread_area of have reserved
entries for it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
