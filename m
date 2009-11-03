Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKCJu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKCJu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZKCJu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:50:28 -0500
Received: from ns.penguin.cz ([84.21.108.25]:58355 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbZKCJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:50:27 -0500
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Stanislav Brabec <utx@penguin.cz>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, dsaxena@laptop.org, alan@linux.intel.com,
       gregkh@suse.de, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org, Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <771cded00911021931x41cfa51bh2959d3748db5ac0@mail.gmail.com>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz> <20091101220341.GA16698@elf.ucw.cz>
	 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
	 <1257155873.5642.14.camel@utx.utx.cz>
	 <771cded00911021931x41cfa51bh2959d3748db5ac0@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 10:50:21 +0100
Message-Id: <1257241821.4269.5.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haojian Zhuang wrote:
> On Mon, Nov 2, 2009 at 5:57 AM, Stanislav Brabec <utx@penguin.cz> wrote:
> > Haojian Zhuang wrote:
> >
> >> Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
> >> XO laptop. Basically what happens is that upon returning from resume,
> >> serial8250_resume_port() will reconfigure the port for high speed
> >> mode and all console output will be garbled, making debug of the
> >> resume path painful. This patch modifies uart_resume_port() to
> >> reset the port to the state it was in before we suspended.
> >
> > See my patch waiting for approval in LKML thread
> > "serial-core: resume serial hardware with no_console_suspend".
> >
> > It attempts to fix it, but I was not yet able to test it due to spitz
> > resume breakage.
> >
> 
> Hi Stanislav,
> 
> At first, your patch can't be applied into my latest codebase. I have
> to update the patch. But the console resume is still blocked after
> applied your patch. It works only after I merge some old code back. My
> modified patch is in below.

Yes, code changed there a bit. I sent rebased patch later in the thread.
Did you try this one? (Well I did not test it yet - in time of sending
resume did not work at all on my Zaurus.)

Your patch is a bit different. I'll test both as soon as possible.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

