Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbZLJVKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbZLJVKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbZLJVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:10:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417AbZLJVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:10:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: What's in asm-generic.git
Date: Thu, 10 Dec 2009 22:10:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com> <200912071614.46166.arnd@arndb.de>
In-Reply-To: <200912071614.46166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <200912102210.12124.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Kv3ThZv1cmw64Vm66nUTkkCPFrXeGQaWYfKk
 Vaq+7BvJgyev/A5I8CAubcWFZOD2GZKIyOK+BHOjsPWd72iuV9
 3kQ3Q9XxfQVNL3vy6C2qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Arnd Bergmann wrote:
> On Monday 07 December 2009, liqin.chen@sunplusct.com wrote:
> > Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-12-04 03:14:08:
> > 
> > Maybe you can add a __NR_set_thread_area define in asm-generic/unsitd.h
> > for tls used.
> 
> Yes, good point. I'll update the syscall list with this, and also check if more
> syscalls have been addded.

I have found now that sys_accept4 was missing. sys_set_thread_area however
is only defined on x86 and mips. Since you don't currently implement this
on score, maybe it would be more appropriate to handle it like the other
architectures do, rather than adding it to asm-generic/unistd.h?

	Arnd
