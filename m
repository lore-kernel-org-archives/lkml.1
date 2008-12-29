Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbYL2QNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbYL2QNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYL2QNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:13:25 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50427 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYL2QNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:13:24 -0500
Date: Mon, 29 Dec 2008 21:35:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229160538.GA5952@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu> <20081229110012.GB11111@linux.vnet.ibm.com> <20081229110533.GA29592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081229110533.GA29592@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-29 12:05:33]:

> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Ingo,
> > 
> > 	kernel crashes after applying the patch, I will retest with 
> > the patch posted at http://lkml.org/lkml/2008/12/29/48
> 
> yes - Yinghai observed this too. Could you check tip/master that has all 
> the fixlets merged up, to make sure it's finally solved? Thanks,
> 
> also, what is the gcc -v output of your compiler?
> 
> 	Ingo

Hi Ingo/Yinghai,

	Thanks for getting it resolved, the latest tip/master boot's up fine :)

$ gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr 
--mandir=/usr/share/man 
--infodir=/usr/share/info 
--enable-shared 
--enable-threads=posix 
--enable-checking=release 
--with-system-zlib 
--enable-__cxa_atexit 
--disable-libunwind-exceptions 
--enable-libgcj-multifile 
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada
--enable-java-awt=gtk 
--disable-dssi 
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
--with-cpu=generic 
--host=x86_64-redhat-linux
Thread model: posix
gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
