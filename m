Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbZAQJwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbZAQJwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 04:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZAQJvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 04:51:54 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49043 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZAQJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 04:51:52 -0500
Date: Sat, 17 Jan 2009 09:51:43 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Rob Landley <rob@landley.net>
Cc: Valdis.Kletnieks@vt.edu,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090117095143.GA20389@shareable.org>
References: <495FEEAF.5020005@zytor.com> <200901160011.11679.rob@landley.net> <15458.1232117682@turing-police.cc.vt.edu> <200901161554.02054.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901161554.02054.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Friday 16 January 2009 08:54:42 Valdis.Kletnieks@vt.edu wrote:
> > On Fri, 16 Jan 2009 00:11:09 CST, Rob Landley said:
> > > P.S.  I still hope autoconf dies off and the world wakes up and moves
> > > away from that.  And from makefiles for that matter.  But in the
> > > meantime, I can work around it with enough effort.
> >
> > What do you propose autoconf and makefiles get replaced by?
> 

> I've never built pidgin from source, but I've got the output of the binutils 
> build in a log file. 
> How many of these tests are actually necessary on an Linux system:

None, but then it's not a Linux-only program that you're compiling.
(Nor is it Linux-in-2009-only).

If you _know_ you're running on Linux from a particular era, you can
provide a config.cache file with the correct answers already filled in.

I agree that Autoconf sucks (I've written enough sucking Autoconf
macros myself, I hate it), but the tough part is providing a suitable
replacement when you still want portable source code.

> It just goes on and on and on like this.  Tests like "checking
> whether byte ordering is bigendian... no" means "Either I didn't
> know endian.h existed, or I don't trust it to be there".  How about
> the long stretches checking for the existence of header files
> specified by posix?

You seem to be arguing for "let's make all our programs Linux-specific
(and Glibc-specific in many cases)".  Given all the problems you've
seen with cross-compiling, let alone compiling for different OS
platforms, that seems a little odd.

-- Jamie
