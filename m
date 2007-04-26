Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbXDZUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbXDZUnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXDZUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:43:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXDZUnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=g3bwAE0nXCuVU+D9mmRCHmstqvEiuRWJGtOKQOZiu5XCdpg4gJeLysGIopDzrbiZcKrJImRqCJ2qxjXA7PnbfeznaNnk40vdP3bDCeQK5YvnLTTKinQCxJ5fxXQ+BFdlXE64S0gCbJMdStktZ2sjXuQmZUFBYH1/z98kQ6f//jw=
Date: Thu, 26 Apr 2007 22:41:48 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070426224148.69b91b2e.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 26 Apr 2007 11:42:22 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:

> I bet that's true even of a lot of people who are more "web oriented" than 
> I am. They may look at webpages, but getting notified by email is still 
> the wakeup call. There's a difference between "active and directed pushing 

Bugzilla sucks quite a lot at email, but you can answer emails and they get
into the bugzilla database; and there're two mailing lists (listed in
Documentation/HOWTO) that send notifications about every new bug
added/modified- I know it's not the perfect email interface every hacker
wants, but it's better than nothing.

I suggested some time ago that it'd be useful to send every new bug
notification from bugme-new to the LKML (and/or other lists). The
volume should not be so high to make it so annoying that it makes it
unuseful, and at least it makes the bugzilla-haters aware of the bugs
reported, and since bugzilla tracks the answers to emails and the
reporter email address is in the email, it makes easier for bugzilla-haters
to ask for more data and try to fix the problem, without starting
any browser.

I can understand Adrian's resign. Bugzilla is crap, but there're users
reporting bugs there and willing to cooperate to fix them, and they're
not getting listened. There're even a few description of patches (ie: "line
6 in foo.c is wrong and it breaks our testing, it should read like this:")
that have been sitting there for *years* and not getting merged. I guess
that Adrian tried to canalize the important regressions to the hackers,
and he got tired of apparently being the only one that cares about getting
them fixed.

So I, or anyone else, could try to do Adrian's job. But if Adrian (a guy
that sends patches to make global functions static 8) got tired
of doing that job, I suspect that I, or anyone else would also got 
tired of it even sooner. There're other big projects with probably
more bug reports than linux, they don't work this way, and they
look more succesful in their bug handling.

So in my humble opinion there's a problem, about how the whole
bug reporting/fixing process works. With the current linux
development model, a good bug reporting/fixing process doesn't
looks optional, since it's important to fix bugs ASAP to get the
fixes into -stable. The fix may go as further as "writing our own
bug tracking software" in the same way git fixed other
development issues, or it may be a human issue, or a mix of the
two.
