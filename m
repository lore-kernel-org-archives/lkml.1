Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbXJPHiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbXJPHiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbXJPHin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:38:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:36257 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758038AbXJPHim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:38:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18pM0EyX3Qp56YZsVP7bmaLS4Ew8a6gOrvDJigF24
	gR+HMVTHYQKP93
Subject: Re: kernel NULL pointer dereference in check_spread+0x0/0x26
From: Mike Galbraith <efault@gmx.de>
To: Jan Blunck <jblunck@suse.de>
Cc: mingo@redhat.com, Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20071012124054.GD8471@hasse.suse.de>
References: <20071012124054.GD8471@hasse.suse.de>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 09:38:37 +0200
Message-Id: <1192520317.22054.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 14:40 +0200, Jan Blunck wrote:
> This is with 2.6.23-mm1 and allmodconfig.
> 
> Seems that se in the following is a NULL pointer.
> 
> 453     static void check_spread(struct cfs_rq *cfs_rq, struct
> sched_entity *se)
> 454     {
> 455     #ifdef CONFIG_SCHED_DEBUG
> 456             s64 d = se->vruntime - cfs_rq->min_vruntime;
> 457
> 458             if (d < 0)
> 459                     d = -d;

Have you hit this again recently?  You and I seem to be the only ones
who have hit it, and here, it either went away, or went into hiding.
I've been trying to tickle this (highly improbable) oops with fork/exit
bombs while other things are running (scribble scribble), and failing to
provoke any adverse reaction.

	-Mike

