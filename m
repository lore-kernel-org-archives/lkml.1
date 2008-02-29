Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbYB2Rmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbYB2Rmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYB2Rmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:42:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbYB2Rmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:42:38 -0500
Date: Fri, 29 Feb 2008 12:41:48 -0500
From: Alan Cox <alan@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, alan@redhat.com
Subject: Re: + redo-locking-of-tty-pgrp.patch added to -mm tree
Message-ID: <20080229174148.GA11425@devserv.devel.redhat.com>
References: <200802230737.m1N7bfLB018553@imap1.linux-foundation.org> <20080223171746.GB7686@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223171746.GB7686@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 08:17:46PM +0300, Oleg Nesterov wrote:
> tiocgpgrp() still does pid_vnr(real_tty->pgrp) lockless, this is not safe, no?
> (the same for do_task_stat).

Fixed both in my tree
