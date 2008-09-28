Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYI1UAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYI1UAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYI1UAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:00:32 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:41695 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYI1UAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:00:31 -0400
Message-ID: <35418.166.70.238.43.1222629892.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080928194536.GC8711@mit.edu>
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
    <20080928194536.GC8711@mit.edu>
Date: Sun, 28 Sep 2008 13:24:52 -0600 (MDT)
Subject: Re: [REQUEST] Clarification from Copyright Holders on 
     FUSE/NDISWRAPPER
From: jmerkey@wolfmountaingroup.com
To: "Theodore Tso" <tytso@mit.edu>, jmerkey@wolfmountaingroup.com,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The intent of the copyright owners is fairly clear; most of the kernel
> (exceptions are noted on a handful of source fils) is to be licensed
> under the terms of the GNU Public License, version 2.  There is
> another long-standing assertion by Linus in the COPYING file:
>
>    NOTE! This copyright does *not* cover user programs that use kernel
>  services by normal system calls - this is merely considered normal use
>  of the kernel, and does *not* fall under the heading of "derived work".
>  Also note that the GPL below is copyrighted by the Free Software
>  Foundation, but the instance of code that it refers to (the Linux
>  kernel) is copyrighted by me and others who actually wrote it.
>
> Given that FUSE drivers communicate to the kernel via /dev/fuse and
> normal system calls, you can draw your own conclusions.  (However,
> most FUSE userspace drivers do utilize libfuse, which available under
> an LGPLv2 license.  If you are using Windows-based source code, and
> linking it against an LGPLv2 license, there may be issues there as
> well.)
>
> All of this is not legal advice, however; if you want real legal
> advise, you need to ask a lawyer, not the FSF, and not LKML.


Thanks Ted,

I have spoken to lots of lawyers about this and to be honest they were
pretty much clueless since the real issues involve definitions about what
technologies are covered in the user space exemptions and which are not,
and your conclusions seem right on the money.   I was advised to ask the
copyright holders their opinions, since this is very much a subjective
determination based upon knowledge of technologies and where the line are
drawn.  The legal issues are well understood -- the definitions on which
technologies are classified as user space vs. kernel and which enjoy the
exemptions and which do not are very much at the discretion of the
copyright holders.

You have eloquently answered the question.  FUSE drivers are under the GPL
and are off limits unless you plan to open source them.  Distributors
linking against Linux also sound like they are off limits too.  Given the
response, Windows Executables installed and linked by a customer are not
prohibited nor is the use of any other consumer of Linux (which is what
the lawyers have told me).

Thanks for the clarification.    I moved this thread to the FUSE list, but
to be honest, it sounds like FUSE is not the way to go.    Free BSD sounds
like the way to go moving forward for these areas.

Thanks,

Jeff





>
> 		    	    	  	      - Ted
>


