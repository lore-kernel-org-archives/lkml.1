Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZFPIgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZFPIgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZFPIgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:36:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39865 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbZFPIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:36:39 -0400
Date: Tue, 16 Jun 2009 09:37:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 01:45:36 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [ Ingo and Andrew, sorry for the repost, but I forgot to Cc LKML and I 
>   also used Alan's old email. ]
> 
> I can easily trigger a bug in the tty code by enabling the event tracers.

Yes I know. I sent Linus a temporary workaround yesterday. The bug is as
old as the hills (the race in various forms predates any git or bk
history!). The ldisc changes happened to make it more visible.

Unfortunately its non trivial to fix but the workaround should make it as
hard to hit now as in 2.6.30 while I sort the funnies out. Really though
I need the lock verifier working to do that, and its been busted since
2.6.30 8(

Alan
