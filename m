Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0BGBPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 20:15:46 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:47951 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab0BGBPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 20:15:45 -0500
From: jidanni@jidanni.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Cc: 330403@bugs.debian.org, torvalds@linux-foundation.org
Subject: Re: sysrq: more explicit, less terse help messages
Date: Sun, 07 Feb 2010 09:15:01 +0800
Message-ID: <87k4upq222.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=330403

Thanks for the fix, however SysRq still has two things that are
non-intelligible to the operator who is locked out of his on-line
reference manuals: "saK" and nice-all-"RT"-tasks. "oom" I suppose you
can leave as a mystery :-) ... but better not, else 4 years from now
I'll Be Back. Better add a comment to the code reminding authors that
the SysRq help messages might be printed in situations where the
operator is otherwise locked out of his computer, so cannot look up what
they mean, so they must be verbose.

Also I noticed that at the four year frequency that I end up using
SysRq, all I remember is that one is supposed to squeeze a combination
of keys that include SysRq and h to get started. Therefore perhaps
mention there in the help message, just what one is actually supposed to
press (the several ways too), so that ones second press will be more
exact, even though they just managed to press it. (Put the answer in the
new help message, not in a reply to me!)

Now that I haven't yet occupied the whole screen with my ideas for a
more verbose SysRq help message, you might also mention there in the
message how the user can page the output of some of the more verbose
commands so that they don't fly off the screen mostly. Or mention if it
is not possible.
