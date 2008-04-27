Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbYD0LcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbYD0LcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYD0LcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:32:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbYD0LcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:32:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Date: Sun, 27 Apr 2008 13:31:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <480F7C11.8040302@zytor.com> <20080427100901.GC3891@ucw.cz>
In-Reply-To: <20080427100901.GC3891@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804271331.18940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 of April 2008, Pavel Machek wrote:
> On Wed 2008-04-23 11:12:33, H. Peter Anvin wrote:
> > Cyrill Gorcunov wrote:
> > >
> > >Hi David,
> > >
> > >actually, this CONFIG_VM86 was there even before the 
> > >renaming was done.
> > >The main questions (imo) - is there any user space 
> > >application who uses
> > >these flags? If they are - then even the idea of this 
> > >patch was a bit bogus,
> > >and I should *not* remove all these VM86 specific flags 
> > >but better define them
> > >as aliases on flags from processor-flags.h.
> > >
> > 
> > Hard to know.  VM86 is only used by a handful of 
> > applications (DOSEMU, X.org, others?) but it's hard to 
> > know what exactly they are.
> 
> I believe vbetool and thus s2ram uses vm86, too.

Well, I think so too. Matthew?

Rafael
