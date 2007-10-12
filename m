Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXJLMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXJLMsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXJLMsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:48:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:60788 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752801AbXJLMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:48:00 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19/ZEtXwAJ/8JCwGQc7M3xwMf77Q4COcNJqIAl9md
	5yLDsCZzIIsIvd
Date: Fri, 12 Oct 2007 14:48:08 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the rationale for "TAINT_USER"?
Message-ID: <20071012124808.GA32693@atjola.homenet>
References: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain> <20071012122719.GB30350@atjola.homenet> <Pine.LNX.4.64.0710120832350.22555@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0710120832350.22555@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.10.12 08:37:04 -0400, Robert P. J. Day wrote:
> On Fri, 12 Oct 2007, Björn Steinbrink wrote:
> 
> > On 2007.10.12 08:04:20 -0400, Robert P. J. Day wrote:
> > >
> > >   i can see what the theoretical purpose for it is here:
> > >
> > > http://kerneltrap.org/node/6656
> > >
> > > but it's not clear how it can possibly be set from userland given
> > > that:
> > >
> > > $ grep -r TAINT_USER *
> > > include/linux/kernel.h:#define TAINT_USER                       (1<<6)
> > > kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
> > > $
> > >
> > >   am i missing something screamingly obvious?
> >
> > Grepping for "tainted" leads me to:
> >
> > echo 32 > /proc/sys/kernel/tainted
> 
> ???.  i have no idea what you were grepping through to find that
> phrase, but TAINT_USER would seem to be equivalent to echo 64, not
> echo 32, anyway, no?

Oops, yeah, 64... And it didn't lead me to the exact phrase, but the
sysctl handler, which (implicitly) led me to that command. Sorry for
the confusion.

Björn
