Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXLHVWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXLHVWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXLHVWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:22:45 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:54686 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbXLHVWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:22:44 -0500
Message-ID: <475B0B11.1090008@oracle.com>
Date: Sat, 08 Dec 2007 13:22:25 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH 1/6] indirect: use asmlinkage in i386 syscall table	prototype
References: <1196983219534-git-send-email-zach.brown@oracle.com>	 <11969832193635-git-send-email-zach.brown@oracle.com> <1197117625.19335.3.camel@odie.local>
In-Reply-To: <1197117625.19335.3.camel@odie.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +	extern asmlinkage long (*sys_call_table[])(long, long, long,
> This should be something like below instead, otherwise gcc wont parse
> asmlinkage as being an attribute of the function signature.
> 	extern long (asmlinkage *sys_call_table[])(long, long, long,

Yeah, thanks for pointing these out.  As it happened, Jens beat you to
it :).

Both problems have been fixed in the git repositories for the guilt
series and userspace tools, respectively.  You can always fetch the most
recent versions from there.

- z
