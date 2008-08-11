Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHKQbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHKQbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYHKQa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:30:59 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:63464 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYHKQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:30:58 -0400
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dario Faggioli <raistlin@linux.it>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1218471794.6450.87.camel@Palanthas>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>  <1218464753.10800.92.camel@twins>
	 <1218471794.6450.87.camel@Palanthas>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 18:30:52 +0200
Message-Id: <1218472252.10800.107.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 18:23 +0200, Dario Faggioli wrote:
> On Mon, 2008-08-11 at 16:25 +0200, Peter Zijlstra wrote:
> > My suggestion would be to create struct sched_param2 with plenty of
> > padding to support future expansion and add
> > sys_sched_setscheduler2()/sys_sched_getscheduler2() to deal with this
> > new structure.
> And we will miss POSIX compliance. :-(
> Anyway, I agree the ABI issue this could raise are serious enough and, I
> repeat, I can't see any other solution too.

Well, a new version of glibc could use those to implement the posix
interface. Because as I understand it, glibc can break ABI on certain
version bumps.

