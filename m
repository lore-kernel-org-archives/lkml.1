Return-Path: <linux-kernel-owner+w=401wt.eu-S932458Ab0AGDLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0AGDLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601Ab0AGDLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:11:12 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51528 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0AGDLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:11:05 -0500
From: Miles Bader <miles@gnu.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the punch card limit
References: <1262796984.1011.17.camel@wall-e>
Reply-To: Miles Bader <miles@gnu.org>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 07 Jan 2010 12:07:56 +0900
In-Reply-To: <1262796984.1011.17.camel@wall-e> (Stefani Seibold's message of
	"Wed, 06 Jan 2010 17:56:24 +0100")
Message-ID: <buopr5mobn7.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:
> The time of 80 characters punch card and terminals are over, so i would
> be a good thing to set the line length limit to 120. Every display today
> should be able handle this. And it think it make formated source code
> more readable.
>
> For everybody who want know: The 80 column limit of a terminal comes
> from the punch cards, which stored exact 80 characters.

It doesn't really matter where it came from, what matters is whether
people still commonly use 80-column windows or not.

I know people that only ever use one (huuuge) full-screen editor window
with small fonts, and can happily view lines that are 300 characters
long (of course, the right 80% of that window is almost always
completely blank...).

In my case, I use 80-column windows because (1) it allows me to have two
editor/terminal windows side-by-side with a reasonable font-size on a
typical display, (2) it reduces the amount of wasted blank space in
editor/terminal windows that you'd have if you made your windows really
wide just for the very occasional wide line, and (3) it's, well,
standard, or at least as much of a standard as we have, which is useful
when interacting with other people.

Anyway, I think the vague consensus seems to be that it's OK to go over
80 chars in many cases, but that it may be an indicator that some
refactoring is in order....

-Miles

-- 
80% of success is just showing up.  --Woody Allen
