Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYJEAs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYJEAs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYJEAsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:48:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:50332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYJEAsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:48:52 -0400
Date: Sat, 4 Oct 2008 17:48:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081004174843.6fe48a8e@infradead.org>
In-Reply-To: <20081005004233.GL10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net>
	<20081004145149.52c34ee7@infradead.org>
	<20081004220220.GK10632@outflux.net>
	<20081004164239.0c1483a4@infradead.org>
	<20081005004233.GL10632@outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 17:42:33 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> On Sat, Oct 04, 2008 at 04:42:39PM -0700, Arjan van de Ven wrote:
> > On Sat, 4 Oct 2008 15:02:20 -0700
> > Kees Cook <kees.cook@canonical.com> wrote:
> > > Nothing else seemed appropriate, but I could make a brand new proc
> > > file, if that's sensible.  "status_private" ?
> > 
> > how about a file called "personality" that has each set bit as an
> > ascii version ?
> > (one per line maybe)
> 
> Well, it's a one-to-many due to how the personality types are defined,
> so doing a bitfield-to-ASCII-names conversion wouldn't really work
> out:
> 
>         PER_SCOSVR3 =           0x0003 | STICKY_TIMEOUTS |
>                                          WHOLE_SECONDS | SHORT_INODE,
>         PER_OSR5 =              0x0003 | STICKY_TIMEOUTS |
> WHOLE_SECONDS, ...
>         PER_BSD =               0x0006,
>         PER_SUNOS =             0x0006 | STICKY_TIMEOUTS,
> 
> But I can certainly just make it a stand-alone file with just the
> bitfield.  Or, I can still do the conversion and ignore PER_OSR5 and
> PER_SUNOS.

well.. if "you" as kernel can't really make out what it is, how is poor
userspace supposed to do it ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
