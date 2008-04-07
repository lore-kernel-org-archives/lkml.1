Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYDGLKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYDGLKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYDGLKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:10:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33774 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYDGLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OPg+MQ+NJB+fbSArd9Tn0rYX3PEsIZPZ6dDdqaelf8xrUUjI8DY/kMD0345gWtRiDm1tsci0X1ex+UyuA1zkezZI3+eObU81x/GQPzduYuIwuztK5OYsy2WZLrYh8DIYwIELqrDveipokN30gVi4on8hx6ISqSGFm8UDQZviy5Y=
Message-ID: <47FA012C.7000509@googlemail.com>
Date: Mon, 07 Apr 2008 13:10:36 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lazy <lazy404@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.24.4 compilation error
References: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com>
In-Reply-To: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lazy wrote:
> make bzImage
> ...
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `getnstimeofday':
> (.text+0x22bdc): undefined reference to `__umoddi3'
> kernel/built-in.o: In function `getnstimeofday':
> (.text+0x22bfc): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `do_gettimeofday':
> (.text+0x22d0e): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `do_gettimeofday':
> (.text+0x22d2c): undefined reference to `__umoddi3'
> kernel/built-in.o: In function `timekeeping_resume':
> timekeeping.c:(.text+0x22fd4): undefined reference to `__umoddi3'
> timekeeping.c:(.text+0x22ff4): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x23306): undefined reference to `__umoddi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x23326): undefined reference to `__udivdi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x23796): undefined reference to `__umoddi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x237b6): undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1


You'll need this patch :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=38332cb98772f5ea757e6486bed7ed0381cb5f98

Gabriel
