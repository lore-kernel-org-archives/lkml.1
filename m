Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZJMQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZJMQ16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZJMQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZJMQ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:27:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
To: John Kacur <jkacur@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 2/6 RFC] arch/frv/kernel/process.c: Remove the BKL from sys_execve
Date: Tue, 13 Oct 2009 17:26:19 +0100
Message-ID: <5140.1255451179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur <jkacur@redhat.com> wrote:

> From 4489496ad43049df06b7ffc37afcea561fdb52b9 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Mon, 12 Oct 2009 22:53:25 +0200
> Subject: [PATCH] arch/frv/kernel/process.c: Remove the BKL from sys_execve
> 
> sys_execve for frv seems to be a copy-and-paste of sys_execve that
> no longer requires the bkl. Just remove it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
