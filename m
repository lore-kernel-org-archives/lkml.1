Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbYD0KKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbYD0KKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYD0KKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:10:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4372 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754083AbYD0KK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:10:29 -0400
Date: Sun, 27 Apr 2008 12:09:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Message-ID: <20080427100901.GC3891@ucw.cz>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <1208917076.9212.721.camel@pmac.infradead.org> <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com> <480F7C11.8040302@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480F7C11.8040302@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-23 11:12:33, H. Peter Anvin wrote:
> Cyrill Gorcunov wrote:
> >
> >Hi David,
> >
> >actually, this CONFIG_VM86 was there even before the 
> >renaming was done.
> >The main questions (imo) - is there any user space 
> >application who uses
> >these flags? If they are - then even the idea of this 
> >patch was a bit bogus,
> >and I should *not* remove all these VM86 specific flags 
> >but better define them
> >as aliases on flags from processor-flags.h.
> >
> 
> Hard to know.  VM86 is only used by a handful of 
> applications (DOSEMU, X.org, others?) but it's hard to 
> know what exactly they are.

I believe vbetool and thus s2ram uses vm86, too.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
