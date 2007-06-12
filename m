Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbXFLPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbXFLPMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXFLPMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:12:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49611 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXFLPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:12:16 -0400
Date: Tue, 12 Jun 2007 08:12:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Federico Paparoni" <federico.paparoni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux kernel 2.4 programming problem
Message-Id: <20070612081235.9c16fd6c.randy.dunlap@oracle.com>
In-Reply-To: <7f7732360706120654i34f34da8q6428e41bc5a76728@mail.gmail.com>
References: <7f7732360706120654i34f34da8q6428e41bc5a76728@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 15:54:57 +0200 Federico Paparoni wrote:

> Hi all,
> i'm trying to create a simple system call in a kernel 2.4 distribution.
> I read guide/articles like this
> 
> http://irfanhabib.wordpress.com/2006/10/01/adding-a-system-call-linux-24x/
> 
> All the articles say the same things, but the implementation of my new
> system call doesn't work.
> I create a new entry in arch/i386/kernel/entry.S
> I create a new entry in include/asm/unistd.h
> I create a new function with the asmlinkage prefix in a source file
> already defined (in ipc/sem.c for example)
> 
> When i create my user program, it doesn't work. Firstly when i try to
> compile i receive a problem like this
> 
> : undefined reference to 'errno'
> 
> Then I include errno.h (also if i don't understand this step) and the
> compilation works, but the syscall neverworks, because the call always
> return -1.
> 
> Any help?
> Any tutorial FOR DUMMY MAN that someone already used?

You can try this one.  It used to work, but I haven't updated or
tested it lately.

http://www.xenotime.net/linux/syscall_ex/

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
