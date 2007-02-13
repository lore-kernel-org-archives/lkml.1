Return-Path: <linux-kernel-owner+w=401wt.eu-S1750742AbXBMPjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750742AbXBMPjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXBMPjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:39:45 -0500
Received: from ns.suse.de ([195.135.220.2]:51667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXBMPjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:39:45 -0500
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
	<20070213150019.4b4d4827@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Feb 2007 17:39:28 +0100
In-Reply-To: <20070213150019.4b4d4827@localhost.localdomain>
Message-ID: <p73hctqggfz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan <alan@lxorguk.ukuu.org.uk> writes:

Funny, it sounds like batch() on stereoids @) Ok with an async context it becomes
somewhat more interesting.
 
> 	sys_setuid/gid/etc need to be synchronous only and not occur
> while other async syscalls are running in parallel to meet current kernel
> assumptions.
> 
> 	sys_exec and other security boundaries must be synchronous only
> and not allow async "spill over" (consider setuid async binary patching)

He probably would need some generalization of Andrea's seccomp work.
Perhaps using bitmaps? For paranoia I would suggest to white list, not black list
calls.

-Andi
