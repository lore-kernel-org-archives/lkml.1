Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXCPXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXCPXUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXCPXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:20:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXCPXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:20:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
In-Reply-To: Jeff Dike's message of  Friday, 16 March 2007 12:25:52 -0400 <20070316162552.GB7948@c2.user-mode-linux.org>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20070316232007.0CE881801C5@magilla.sf.frob.com>
Date: Fri, 16 Mar 2007 16:20:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Did I send the right patch?  The one I meant to send (appended below),
> indeed builds and runs without utrace-regset.patch and
> utrace-core.patch applied.  It's utrace-1 in the following:

That is not the same patch I tried before.  This one does apply and build
fine (after make defconfig ARCH=um).  

Technically utrace_native_view doesn't belong in the tracehook patch (but
in the regset one to follow it), but it is harmless.

I've merged it into my current tree.  You can get this via GIT if you like
that.  I do regular merges from Linus's GIT tree, so any upstream UML
changes that merge cleanly or have trivial conflict fixes I can do will be
taken care of automatically.  For future updates, please send me
incremental changes based on my current stuff; the GIT branches and the
2.6-current patches on my utrace web page always match up.  My patch set
generation uses just one fixed log message for utrace-tracehook-um.patch,
so tell me if you want to adjust it from log text in today's patch.


Thanks,
Roland
