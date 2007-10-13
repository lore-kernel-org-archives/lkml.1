Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXJMDhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXJMDhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 23:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXJMDhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 23:37:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:56213 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752527AbXJMDhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 23:37:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19/h3UjgaB/x3Dwv6wKZfSRR+LAe1drQXkobwSzLv
	42RKhNOIXt4vqn
Subject: Re: kernel NULL pointer dereference in check_spread+0x0/0x26
From: Mike Galbraith <efault@gmx.de>
To: Jan Blunck <jblunck@suse.de>
Cc: mingo@redhat.com, Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20071012124054.GD8471@hasse.suse.de>
References: <20071012124054.GD8471@hasse.suse.de>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 05:36:56 +0200
Message-Id: <1192246616.7395.21.camel@Homer.simpson.net>
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

I hit this once yesterday (in sched-devel), and again first boot this
morning.

	-Mike

