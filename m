Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXBOTTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXBOTTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXBOTTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:19:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1094 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030721AbXBOTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:19:04 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 11:19:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/14] syslets: core, documentation
In-Reply-To: <20070215175654.GA20997@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702151117460.11064@alien.or.mcafeemobile.com>
References: <20070215165232.GG4285@elte.hu> <20070215175654.GA20997@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:

> On Thu, Feb 15, 2007 at 05:52:32PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> > +user-space memory, which is the basic unit of execution within the syslet
> > +framework. A syslet represents a single system-call and its arguments.
> > +In addition it also has condition flags attached to it that allows the
> > +construction of larger programs (syslets) from these atoms.
> > +
> > +Arguments to the system call are implemented via pointers to arguments.
> 
> I've just thought, how x86/x86_64 problem is going to be solved for
> pointer size? Is it better to wire longs/pointers to 64 bits right now?

Compat code is gonna to be fun also for that (pointers to args, and "next" 
chaining pointer).



- Davide


