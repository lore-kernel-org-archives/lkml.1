Return-Path: <linux-kernel-owner+w=401wt.eu-S936092AbYBAFIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936092AbYBAFIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934936AbYBAFIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:08:34 -0500
Received: from c60.cesmail.net ([216.154.195.49]:15757 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935184AbYBAFIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:08:32 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: rms@gnu.org
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, jonathan@jonmasters.org,
       rusty@rustcorp.com.au, pgiri@yahoo.com
In-Reply-To: <E1JKJvh-0006P8-Pi@fencepost.gnu.org>
References: <1201641765.18773.35.camel@dv>
	 <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv>
	 <E1JKJvh-0006P8-Pi@fencepost.gnu.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 00:08:30 -0500
Message-Id: <1201842510.18433.88.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 15:53 -0500, Richard Stallman wrote:
> I don't know what the circumstances are in this case, since the
> description quoted was quite sketchy.  I suggest that someone send a
> clear description of the case to licensing@gnu.org to find out what
> GPLv2 implies about it.

I don't think anyone implies that there are any real copyright issues
with ndiswrapper, at least in the US.  With all differences in
intonations, everybody seems to understand that.

It's understandable that kernel developers feel uncomfortable about
ndiswrapper, which loads non-free Windows drivers into the kernel
memory.  It's understandable that kernel developers don't want to
support systems where such code has been running at any time.

It's understandable that ndiswrapper can be considered as an unwelcome
alternative to free drivers, although it's actually used for reverse
engineering and it allows to check that the unsupported hardware is
functional without having to boot to a non-free OS.  A kernel that did
something unsupportable becomes "tainted".

Unfortunately, the code for making ndiswrapper taint the kernel is
similar to the code that makes non-free modules (i.e. non-free software
specifically designed to work with Linux) taint the kernel.  That's why
is has happened for the second time already that ndiswrapper was lumped
together with non-free modules and disallowed to use certain kernel
facilities that were only meant for free software.

Even though it was done by mistake both times, it looked as an
intentional change every time.  It is an emotional issue, but it has
little to do with copyright issues and more with understandable
antipathy of the kernel developer towards non-free software running with
the kernel privileges.

I think the whole idea to bring you into the discussion was based on
misunderstanding of my use of the word "linking".  There is a difference
between compiling and linking a non-free program from the source code
against free headers and free libraries and loading non-free code and
making it work by emulating non-free interfaces with free software.

I was merely saying that the later is OK.  I was not advocating the
former.

> If my message does not appear on linux-kernel@vger.kernel.org,
> would one of you please forward it?

It did appear on the list.

> It is not in general the case that "dynamic linking cannot violate the
> GPL".  It depends on circumstances.  Running a non-free program in a
> process in a GNU/Linux system is not linking of any kind with Linux.
> The program probably links with GNU libc, but the license of GNU libc
> permits that.

A better analogy would be running a non-free program in a free emulator.

I don't have any issues with ndiswrapper.  If anyone does, they should
write to FSF, or maybe to FSF Europe if the concern are about European
laws.

-- 
Regards,
Pavel Roskin
