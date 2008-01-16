Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbYAPEF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbYAPEF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYAPEFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:05:17 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:34748 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbYAPEFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:05:15 -0500
Date: Tue, 15 Jan 2008 23:04:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Valdis.Kletnieks@vt.edu
cc: caglar@pardus.org.tr, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <24149.1200455417@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.58.0801152302580.10869@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>           
 <200801150237.44029.caglar@pardus.org.tr> <24149.1200455417@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 15 Jan 2008 02:37:37 +0200, =?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur said:
> > And because of mcount-add-basic-support-for-gcc-profiler-instrum.patch, closed
> > source nvidia-new module cannot be used with this release (mcount is exported
> > GPL only), i know this is not supported but i used it with that [2] patch up
> > until now without a single problem.
>
> Playing devil's advocate here - the claim is that EXPORT_SYMBOL_GPL is to
> indicate that code is getting too chummy with Linux internals.
>
> However, in *this* case, isn't it "code that is too chummy with *GCC* internals",
> and thus it isn't our place to say what can and can't be done with code that
> is derivative of the GCC compiler? ;)

Actually, it got put in there by accident. I usually default all my
exports as GPL.  But this breaks pretty much everything, so I'll leave it
as EXPORT_SYMBOL.

-- Steve

