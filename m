Return-Path: <linux-kernel-owner+w=401wt.eu-S1161168AbXAZSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161168AbXAZSpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161167AbXAZSpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:45:53 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:10595 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162AbXAZSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZWu20xiPuyS7+KPr8uU2SsZ1mPPnhQaHMJzmbusxX35Kzq7jYEdgpeOOiDT/95enLMOOMLT8AW/O6cUt0C2w1KNghSs+AUQah7WrZp2SSS99DSN6J0UHN1Y3xRBGpzYskdZZXW3cgAxUjN/fc9G6FpYTPrx6LDUhQYcMzcsDV5Q=
Message-ID: <6bffcb0e0701261045q29cdb4ceq4577e5b0cec55d66@mail.gmail.com>
Date: Fri, 26 Jan 2007 19:45:39 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	 <45BA42B9.7020203@googlemail.com>
	 <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com>
	 <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Fri, 26 Jan 2007, Michal Piotrowski wrote:
>
> > mm/page_alloc.c: In function 'nr_free_inactive_pages_node':
> > mm/page_alloc.c:1588: error: 'struct zone' has no member named 'nr_inactive'
> > mm/page_alloc.c:1589: error: 'struct zone' has no member named 'free_pages'
> > make[1]: *** [mm/page_alloc.o] Error 1
> > make: *** [mm] Error 2
>
> I cannot get it to compile either:
>
> christoph@schroedinger:~/software/linux/xx/linux-2.6.20-rc6$ make
> mm/page_alloc.o
> scripts/kconfig/conf -s arch/i386/Kconfig
> Warning! Found recursive dependency: INET GFS2_FS_LOCKING_DLM SYSFS
> OCFS2_FS INET
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/i386/kernel/asm-offsets.s
> In file included from include/linux/sched.h:87,
>                  from include/linux/utsname.h:35,
>                  from include/asm/elf.h:12,
>                  from include/linux/elf.h:7,
>                  from include/linux/module.h:15,
>                  from include/linux/crypto.h:21,
>                  from arch/i386/kernel/asm-offsets.c:7:
> include/linux/nsproxy.h: In function 'preexit_task_namespaces':
> include/linux/nsproxy.h:56: error: dereferencing pointer to incomplete
> type
> make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Please try patches from
http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/

http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/bugs_and_patches.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
