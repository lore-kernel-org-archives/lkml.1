Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796Ab0AMLrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0AMLrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178Ab0AMLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:47:00 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:51637 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab0AMLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:46:59 -0500
Date: Wed, 13 Jan 2010 12:46:51 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Stanislav Brabec <utx@penguin.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Eric <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       gregkh@suse.de, Haojian Zhuang <haojian.zhuang@marvell.com>,
       kernel list <linux-kernel@vger.kernel.org>, dsaxena@laptop.org,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       thommycheck@gmail.com, Dirk@opfer-online.de,
       linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: Possible suspend/resume regression in .32-rc?
Message-ID: <20100113114651.GJ8970@buzzloop.caiaq.de>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
 <20091101205449.GT14091@buzzloop.caiaq.de>
 <20091101213343.GA31345@elf.ucw.cz>
 <20091101220341.GA16698@elf.ucw.cz>
 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
 <1257155873.5642.14.camel@utx.utx.cz>
 <771cded00911021931x41cfa51bh2959d3748db5ac0@mail.gmail.com>
 <1257241821.4269.5.camel@utx.utx.cz>
 <771cded00911042106u39fd3655mae50a89bd419411b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771cded00911042106u39fd3655mae50a89bd419411b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 12:06:13AM -0500, Haojian Zhuang wrote:
> On Tue, Nov 3, 2009 at 4:50 AM, Stanislav Brabec <utx@penguin.cz> wrote:
> > Haojian Zhuang wrote:
> >> On Mon, Nov 2, 2009 at 5:57 AM, Stanislav Brabec <utx@penguin.cz> wrote:
> >> > Haojian Zhuang wrote:
> >> >
> >> >> Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
> >> >> XO laptop. Basically what happens is that upon returning from resume,
> >> >> serial8250_resume_port() will reconfigure the port for high speed
> >> >> mode and all console output will be garbled, making debug of the
> >> >> resume path painful. This patch modifies uart_resume_port() to
> >> >> reset the port to the state it was in before we suspended.
> >> >
> >> > See my patch waiting for approval in LKML thread
> >> > "serial-core: resume serial hardware with no_console_suspend".
> >> >
> >> > It attempts to fix it, but I was not yet able to test it due to spitz
> >> > resume breakage.
> >> >
> >>
> >> Hi Stanislav,
> >>
> >> At first, your patch can't be applied into my latest codebase. I have
> >> to update the patch. But the console resume is still blocked after
> >> applied your patch. It works only after I merge some old code back. My
> >> modified patch is in below.
> >
> > Yes, code changed there a bit. I sent rebased patch later in the thread.
> > Did you try this one? (Well I did not test it yet - in time of sending
> > resume did not work at all on my Zaurus.)
> >
> > Your patch is a bit different. I'll test both as soon as possible.
> >
> >
> 
> Your latest patch works well in my platform. Thanks a lot.

It seems Stanislav's patch is still unmerged in the current git HEAD.
Any idea why it is held back? I have it applied locally since quite a
while here, and it works well. So if it helps, take my Tested-by: for
it.

Daniel

