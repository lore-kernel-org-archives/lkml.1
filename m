Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbZFKT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbZFKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbZFKT7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:59:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130AbZFKT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:59:07 -0400
Date: Thu, 11 Jun 2009 12:58:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hch@infradead.org, a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk,
       mingo@elte.hu, davem@davemloft.net, eranian@googlemail.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, tglx@linutronix.de
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-Id: <20090611125804.411095e8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	<20090611161714.GA5008@infradead.org>
	<alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	<20090611165226.GV8633@ZenIV.linux.org.uk>
	<1244739378.6691.540.camel@laptop>
	<20090611170015.GA3651@infradead.org>
	<alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 10:06:55 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> You haven't actually looked the real problem in the eye, and acknowledged 
> the disaster that is oprofile. Let's give a _new_ approach a chance, and 
> see if we can avoid the mistakes of yesteryear this time.

+1, metoo.

We've had numerous problems in the past where kernel developers have
shied away from altering or distributing userspace code.  One effect of
this which we see again and again is that people shove presentation and
parsing code into the kernel which should have been in userspace.

It could be that shipping userspace code in the kernel bundle will
improve that situation.  So let's give it a try.  If it turns out to be
good, let's do it again.  If it turns out to be bad, let's move perf
out of the kernel tree and not do it again.


