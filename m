Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYI1Tpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYI1Tpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 15:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYI1Tpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 15:45:40 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47597 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896AbYI1Tpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 15:45:39 -0400
Date: Sun, 28 Sep 2008 15:45:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REQUEST] Clarification from Copyright Holders on
	FUSE/NDISWRAPPER
Message-ID: <20080928194536.GC8711@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 11:15:53AM -0600, jmerkey@wolfmountaingroup.com wrote:
> I have been involved in numerous discussions with a variety of folks,
> including Bruce Perens regarding the new policy governing kernel drivers
> created for specific hardware/features and the Linux Foundations position
> on proprietary hardware drives.

The position statement on closed-source Linux Kernel Modules was
deliberately not a "policy statement", nor did it talk about issues
about what is or isn't legal.  This was deliberate.  Issues over
whether or not the GPL covers binary modules fundamentally depend on
individual legal jourisdictions' interpretations of copyright law and
derivitive works, and that was something which the kernel developers
who worked on the language of said joint position statement
deliberately stayed away from that question.

> The consensus opinion from Bruce and others seems to be that applications
> that use normal system services on Linux do not appear to be involved in
> GPL related issues.

If you need legal advice, you need to pay a lawyer to apply the facts
of the your particular situation to the law, in a particular legal
jourisdiction, and then give you official legal advice.  Opinions by
kernel developers aren't particularly useful here, and is off-topic
for this mailing list.

The intent of the copyright owners is fairly clear; most of the kernel
(exceptions are noted on a handful of source fils) is to be licensed
under the terms of the GNU Public License, version 2.  There is
another long-standing assertion by Linus in the COPYING file:

   NOTE! This copyright does *not* cover user programs that use kernel
 services by normal system calls - this is merely considered normal use
 of the kernel, and does *not* fall under the heading of "derived work".
 Also note that the GPL below is copyrighted by the Free Software
 Foundation, but the instance of code that it refers to (the Linux
 kernel) is copyrighted by me and others who actually wrote it.

Given that FUSE drivers communicate to the kernel via /dev/fuse and
normal system calls, you can draw your own conclusions.  (However,
most FUSE userspace drivers do utilize libfuse, which available under
an LGPLv2 license.  If you are using Windows-based source code, and
linking it against an LGPLv2 license, there may be issues there as
well.)

All of this is not legal advice, however; if you want real legal
advise, you need to ask a lawyer, not the FSF, and not LKML.

		    	    	  	      - Ted
