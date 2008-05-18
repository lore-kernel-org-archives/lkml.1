Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYERVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYERVP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYERVPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:15:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbYERVPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:15:18 -0400
Date: Sun, 18 May 2008 23:15:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
In-Reply-To: <20080518204258.GL8140@cs181133002.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0805182314450.15590@fbirervta.pbzchgretzou.qr>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com> <20080515173539.GA23959@uranus.ravnborg.org> <20080515174015.GA24024@uranus.ravnborg.org> <482C8CBE.2060101@gmail.com> <20080515204632.GG1936@cs181133002.pp.htv.fi>
 <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr> <20080518204258.GL8140@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-05-18 22:42, Adrian Bunk wrote:
>> On Thursday 2008-05-15 22:46, Adrian Bunk wrote:
>> >>
>> >> Well, the compiler is the same, but it's told to compile the kernel with  
>> >> -m64. It runs on x86_64 kernel and i386 userspace. It's debian i386 gcc  
>> >> package which understands x86_64 objects too. No SUBARCH option, it seems 
>> >> to default to x86_64.
>> >>...
>> >
>> >Unless you manually fiddle with ARCH you can only build a kernel with 
>> >the same 32<->64bit setting as your currently running kernel (no matter 
>> >which userspace you use)...
>> 
>> echo -en '#!/bin/bash\nexec gcc -m32 "$@"\n' >/usr/local/bin/i386-linux-gcc
>> make CC=i386-linux-gcc
>> then the if($(CC),$(HOSTCC)) check should get true.
>
>No doubt that you can work around the problem.
>
>But that's not a solution.

Of course not. Ever since the arch unification, building for the
other bitness in bi- or multiarch systems has become harder.
