Return-Path: <linux-kernel-owner+w=401wt.eu-S1031060AbXD2SvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031060AbXD2SvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031061AbXD2SvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:51:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031060AbXD2SvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:51:13 -0400
Date: Sun, 29 Apr 2007 11:49:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Uwe Bugla <uwe.bugla@gmx.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org, mkruky@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
In-Reply-To: <20070429182209.267430@gmx.net>
Message-ID: <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
References: <20070429182209.267430@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Uwe Bugla wrote:
> 
> And now comes the critical point:
> If I use kernel 2.6.21 in connection with git2 (NOT: git1) everything is fine so far.

Sounds like the sis900 network driver problem.

> BUT: This 2.6.21-git2 is unusable in so far as it contains regressive code
> in the dvb-section, authored by Trent Piepho, acked by Michael Krufky, and signed-off-by Mauro Carvalho Chehab:

You never explained what the problem even was, apart from compiling in 
some code that you didn't need to before. Didn't it work in the end?

If it worked, I don't see what the big issue was. You are getting a _lot_ 
of other code in the kernel that you probably never use, you may not even 
have realized.

Uwe, you really aren't helping yourself by being so damn abrasive. I know 
for a fact that your bug-reports are going ignored by some people, and I'm 
not surprised at all.

			Linus
