Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZFPKDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZFPKDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZFPKDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:03:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54445 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750942AbZFPKDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:03:16 -0400
Date: Tue, 16 Jun 2009 11:04:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616110419.14bc9485@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616100015.GD6432@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
	<20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
	<20090616085028.GA13771@elte.hu>
	<20090616095706.36f01282@lxorguk.ukuu.org.uk>
	<20090616100015.GD6432@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  stack-trace entries:                262144 [max: 262144]
> 
> stack-trace entries ran out. And it seems like you didnt quadruple 
> MAX_STACK_TRACE_ENTRIES to 1 million entries.

I did a while ago but would have been another kernel config.

> Do we run out of entries right during bootup? Are you 
> loading/unloading modules a lot perhaps? Could you send your .config 
> please? (assuming a plain bootup triggers it - that should make it 
> reproducible to me too)

On bootup with a totally generic Fedora 11, thinkpad setup with the kernel
swapped for current git head. Will send the .config off list and build it
with a 1M entry stack trace again.

Alan
