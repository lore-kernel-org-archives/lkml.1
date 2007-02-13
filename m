Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXBMU06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXBMU06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXBMU06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:26:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4255 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXBMU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:26:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 12:26:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <Pine.LNX.4.64.0702130817440.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702131225241.32055@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
 <20070213150019.4b4d4827@localhost.localdomain> <p73hctqggfz.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0702130817440.8424@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Linus Torvalds wrote:

> 	if (in_async_context())
> 		return -EINVAL;
> 
> or similar. We need that "async_context()" function anyway for the other 
> cases where we can't do other things concurrently, like changing the UID.

Yes, that's definitely better. Let's have the policy about weather a 
syscall is or is not async-enabled, inside the syscall itself. Simplify 
things a lot.



- Davide


