Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXBZSDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXBZSDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030384AbXBZSDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:03:35 -0500
Received: from mail.screens.ru ([213.234.233.54]:34126 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030383AbXBZSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:03:35 -0500
Date: Mon, 26 Feb 2007 21:06:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Message-ID: <20070226180635.GA644@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
>
> On Mon, Feb 26, 2007 at 09:10:22AM -0800, Linus Torvalds wrote:
> >
> > It is in fact possible that the floppy failure might just be from some
> > timing-dependent thing, and the slowdown itself is the problem.
> >
> > Although I do find that a bit unlikely, since machines these days are
> > about a million times faster than they used to be, so even if it's
> > unnecessarily slow, it shouldn't be noticeable for a floppy drive.
> >
> I don't know enough about the floppy driver to comment on this but I would
> agree with you here.

I know nothing about floppy, but I guess the reason is floppy_disable_hlt().

Sorry for the offtopic question, is it really needed? According to grep, floppy
is the only one user of disable_hlt().

Oleg.

