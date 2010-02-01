Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0BAVLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:11:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56098 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0BAVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:11:04 -0500
Date: Mon, 1 Feb 2010 22:11:02 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ftrace: re-enable dynamic ftrace for ARM
Message-ID: <20100201211101.GB26532@pengutronix.de>
References: <1264959196-5175-1-git-send-email-rabin@rab.in> <1264959196-5175-2-git-send-email-rabin@rab.in> <20100201102843.GA31714@pengutronix.de> <20100201165318.GA1846@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100201165318.GA1846@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 01, 2010 at 10:23:19PM +0530, Rabin Vincent wrote:
> On Mon, Feb 01, 2010 at 11:28:43AM +0100, Uwe Kleine-König wrote:
> > On Sun, Jan 31, 2010 at 11:03:16PM +0530, Rabin Vincent wrote:
> > > This adds mcount recording and updates dynamic ftrace for ARM to work
> > > with the new ftrace dyamic tracing implementation.
> [...]
> > Wouldn't it be nice to patch out the instruction pushing lr to the
> > stack (in the gnu case)?  Should work, shouldn't it.
> 
> It would and it should, but the main reasons I didn't do that were:
> 
>   - Thumb-2 support needs the LR to be in place, since even -mapcs-frame
>     does not seem to give us an APCS frame there.   The LR would also
>     be needed if GCC gains the ability to build without frame pointers
>     with -pg.
> 
>   - I'm not sure we would gain much performance by patching it out, and
>     I'd really like to avoid patching more than what is really necessary
>     and to keep the code as similar as possible to the other arches.
That's OK for me.  Then the only thing that would be nice would be some
more documentation.  E.g. how looks the function prologue in the two
cases, which of these instruction is patched?

This doesn't need to be a stopper for your patch, it's on my long term
todo list already to add some documentation to the (non-dynamic) ftrace
on arm.  I wouldn't mind to add the documentation myself, but not now.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
