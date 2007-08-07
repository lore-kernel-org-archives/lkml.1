Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbXHGHhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbXHGHhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXHGHhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:37:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbXHGHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:37:33 -0400
Date: Tue, 7 Aug 2007 00:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org, Christoph Hellwig <hch@lst.de>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Problems with timerfd()
Message-Id: <20070807003613.f0333b49.akpm@linux-foundation.org>
In-Reply-To: <46B81745.9010409@gmx.net>
References: <46A44B7D.3030700@gmx.net>
	<20070722233826.20efa6e5.akpm@linux-foundation.org>
	<46A7940B.4070901@gmx.net>
	<20070725151252.8d2d5141.akpm@linux-foundation.org>
	<46B81745.9010409@gmx.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 08:55:01 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:

> I'm working on the changes to timerfd(), but must admit I am struggling to
> understand some of the kernel code for working with userspace timers (e.g.,
> in kernel/posix-timers.c).

Join the club.

>  Can you suggest anyone who could provide assistance?

The code was originally contributed by George Anzinger.  He has moved on
and Thomas Gleixner now does most work in there.  I'd expect that Thomas is
your guy, but he is nearing the end of a two-week vacation and will
presumably return to an akpm-sized inbox, so I'd give him a little time ;)

