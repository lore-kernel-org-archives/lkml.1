Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbYKRC3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbYKRC3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYKRC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:29:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKRC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:29:22 -0500
Date: Mon, 17 Nov 2008 21:29:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811172128380.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Steven Rostedt wrote:
> 
> On Mon, 17 Nov 2008, Steven Rostedt wrote:
> > 
> > Note, I was using a default config that had CONFIG_IRQSTACKS off and
> > CONFIG_PPC_64K_PAGES on.
> 
> Here's my stack after boot up with CONFIG_IRQSTACKS set. Seems that 
> softirqs still use the same stack as the process.
> 

By-the-way, my box has been running stable ever since I switched to 
CONFIG_IRQSTACKS.

-- Steve

