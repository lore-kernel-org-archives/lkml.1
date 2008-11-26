Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYKZRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYKZRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYKZRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:13:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYKZRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:13:46 -0500
Date: Wed, 26 Nov 2008 12:13:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Detecting endianness in scripts/recordmcount.pl?
In-Reply-To: <20081126135441.GB28170@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0811261213300.26743@gandalf.stny.rr.com>
References: <20081126083905.GA20472@linux-sh.org> <20081126135441.GB28170@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Sam Ravnborg wrote:

> On Wed, Nov 26, 2008 at 05:39:05PM +0900, Paul Mundt wrote:
> > Presently there doesn't seem to be any way to determine whether the
> > target is big or little endian, and it is assumed that the compiler will
> > do the right thing by default. Unfortunately this can not be assumed,
> > and mismatches ensue, resulting in the linker bailing out.
> > 
> > The only obvious solution I saw was to pass in KBUILD_CFLAGS and ld_flags
> > along with $(CC) and $(LD) to the script, and killing off the hardcoded
> > flags. This at least gets things building, but that still leaves objcopy
> > and objdump as the odd ones out. On the other hand, the format can be figured
> > out by objdumping the object and reading in the file format line, but people
> > obviously do not have consistent naming for these, and a double-pass would
> > be needed -- once for establishing little or big, followed by figuring out
> > which set of regexes to use.
> > 
> > The CONFIG_64BIT test could likewise be adopted for testing endianness, but
> > not all architectures have config options for endian selections.
> But we could add this - no?
> Much better than executing objdump one thousand times.

Adding a parameter would be better.

-- Steve

