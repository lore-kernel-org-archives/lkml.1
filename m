Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYDVJ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYDVJ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbYDVJ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:58:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbYDVJ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:58:06 -0400
Date: Tue, 22 Apr 2008 05:56:21 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
Message-ID: <20080422095621.GT2255@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <480D586C.1030305@sandeen.net> <200804221057.33324.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221057.33324.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:57:33AM +0200, Denys Vlasenko wrote:
> You do not see reduced stack usage in "make checkstack",
> because "make checkstack" shows only stack usage caused by
> local variables (it analyses sub %esp,NN instructions which
> make room for them). Parameters also take up stack, but
> they are pushed on stack with push instruction,
> and so are invisible in "make checkstack" output.

That on i?86 actually depends on whether -maccumulate-outgoing-args
is on or off (the default is off for -Os and most pre-i686 tunings,
and on for i686 and most post-i686 tunings when not -Os).

	Jakub
