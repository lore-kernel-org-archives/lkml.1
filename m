Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYAQD0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYAQD0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYAQD0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:26:42 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45490 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYAQD0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:26:41 -0500
Date: Wed, 16 Jan 2008 22:26:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luotao Fu <l.fu@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2 [PATCH] latency tracer fix for ppc32
In-Reply-To: <20080116120307.GI5859@pengutronix.de>
Message-ID: <Pine.LNX.4.58.0801162223120.21116@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>
 <20080115162729.GF5859@pengutronix.de> <Pine.LNX.4.58.0801151301550.26624@gandalf.stny.rr.com>
 <20080116120307.GI5859@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Luotao Fu wrote:
>
> I found out that the tracer got stuck on ppc32 platforms because some early
> functions call _mcount before mcount_enabled is initialized at all. I made a
> patch, which marks these functions as notrace to solve this problem. With this
> patch I can successfully boot up our mpc5200b platform and make latency trace.
> (tested with -b switch in cyclictest). Please comment.
>
> I made my patch against the -rt2 tree since the dummy call early_printk() in
> -rt3 conflicts with our implementation of a functional early_printk(). It
> should also work with -rt3 though.
>

Thanks, applied.

But for future reference, if you attach your patch please name it with the
ending of .patch and not .diff. Also do it at a -p1 level and not -p0.

-- Steve

