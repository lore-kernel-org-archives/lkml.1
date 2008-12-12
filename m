Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYLLUxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYLLUxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYLLUw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:52:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYLLUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:52:59 -0500
Date: Fri, 12 Dec 2008 15:52:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
In-Reply-To: <20081212204724.GA26194@localhost>
Message-ID: <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Dec 2008, Cyrill Gorcunov wrote:

> [Steven Rostedt - Fri, Dec 12, 2008 at 03:19:27PM -0500]
> | 
> ... 
> | > 
> | > Ah, the patch is on top of -tip e3bdf48
> | 
> | If you have tested this with and without dynamic ftrace, for both the
> | function tracer and the function graph tracer, then you have my...
> | 
> | Acked-by: Steven Rostedt <srostedt@redhat.com>
> | 
> | -- Steve
> ...
> 
> Thanks Steven! Actually just catched a bug :) I placed
> these macros under CONFIG_DYNAMIC_FTRACE but have them
> used even if it was undefined -- will fix shortly.
> 
> Well... I think the macros should be placed in differen
> location (maybe in header) to not overload the source.

You can put them in arch/x86/include/asm/ftrace.h That's assembly safe.

-- Steve

