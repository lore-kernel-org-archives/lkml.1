Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFLDIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFLDIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 23:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYFLDI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 23:08:26 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:35544 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYFLDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 23:08:25 -0400
Date: Wed, 11 Jun 2008 23:08:17 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc5
In-reply-to: <alpine.LFD.1.10.0806111718240.3101@woody.linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.1.10.0806112301570.12191@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
 <alpine.LFD.1.10.0806111718240.3101@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >  27 files changed, 255 insertions(+), 180 deletions(-)
> 
> Hmm. I get very different statistics:
> 
>  27 files changed, 434 insertions(+), 359 deletions(-)
> 
> You seem to use "git diff -w" to ignore whitespace changes, which explains 
> it, but please don't - it makes it harder to compare with expected 
> results, and it hides some changes entirely.
> 
> I do agree that using '-w' is often useful, but especially for the purpose 
> of letting people know what changed it kind of avoids the point by hiding 
> many things.

Yes, I've been using "-b" recently:

git diff -b -M --stat linus..$RELEASE

and if I remove the "-b", we match:

 27 files changed, 434 insertions(+), 359 deletions(-)

I have a vague memory of having a good reason to cut over to "-b"
a while back and noting that in my pull request, but if you prefer
no -b, no problem.

thanks,
-Len
