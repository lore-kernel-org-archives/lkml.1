Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZJXTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZJXTng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZJXTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 15:43:35 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36940 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZJXTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 15:43:29 -0400
Date: Sat, 24 Oct 2009 21:43:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091024194331.GA6234@merkur.ravnborg.org>
References: <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <4AE2F0F6.30909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE2F0F6.30909@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We should rely less on linux-next as a cross-compile farm; that's not
> its purpose.  We can cross-compile ourselves.

Hmm, last time I tried to build binutils/gcc I only got:
   
   alpha arm sparc64 i386 x86_64 um m68k

working.

I recall that I managed to build sh and avr32 alas no luck.
So please do not expect people that touches code impacting
lots of architectures to provide the same level of coverage
that -next does.

Hay - and sometimes I even fail to buil for all the architectures
I have build tool for.

	Sam
