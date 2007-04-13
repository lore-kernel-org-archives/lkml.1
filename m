Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXDMVi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXDMVi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXDMVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:38:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42648 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811AbXDMVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:38:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change kernel threads to ignore signals instead of blocking them
References: <20070413073116.GA1540@tv-sign.ru>
	<m1bqhspdkj.fsf@ebiederm.dsl.xmission.com>
	<20070413140802.3798a6bc.akpm@linux-foundation.org>
Date: Fri, 13 Apr 2007 15:36:52 -0600
In-Reply-To: <20070413140802.3798a6bc.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 13 Apr 2007 14:08:02 -0700")
Message-ID: <m1ps68neh7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> jffs2 actually wants its head examined.  W. T. F. does it think it's
> doing in there?

Good question, especially with respect to SIGHUP.

It is on my short list of very annoying kernel threads...

NFS and a few kernel threads others currently need a way to abort an
interruptible sleep when the are terminated.  Which has been a pain
finding a simple way to allow that without too much trouble.

I'm within about a day of having everything converted over to
kthreads, allowing me to kill daemonize.  Hopefully things I don't run
into any serious snags in testing...

Eric
