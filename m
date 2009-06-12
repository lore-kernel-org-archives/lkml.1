Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbZFLHft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbZFLHft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZFLHfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:35:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41077 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753024AbZFLHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:35:40 -0400
Date: Fri, 12 Jun 2009 08:35:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612083544.65d88b40@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0906111548250.3535@localhost.localdomain>
References: <20090611165226.GV8633@ZenIV.linux.org.uk>
	<1244739378.6691.540.camel@laptop>
	<20090611170015.GA3651@infradead.org>
	<alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	<33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
	<alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
	<20090611202341.GA23590@elte.hu>
	<1244753357.27363.82.camel@violet>
	<20090611210810.GA9317@uranus.ravnborg.org>
	<1244755036.27363.93.camel@violet>
	<20090611212635.GA9446@uranus.ravnborg.org>
	<4A3182C6.803@gmail.com>
	<alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
	<20090611233803.4876b1fb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0906111548250.3535@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, you'd always update the 'kernel-perftool' package (or whatever you'd 
> call it) when you update the kernel. But so what? It's going to be tiny. 
> And appropriate.
> 
> IOW, where's the downside?

Why you need to update the perftool not the kernel, which is very likely
to be the case early on. There are ways for vendors to cope anyway - such
as by deleting the tools directory from their kernel and keeping a
separate perftool package that gets updated now and then from the kernel
tree but is otherwise a fork

Alan
