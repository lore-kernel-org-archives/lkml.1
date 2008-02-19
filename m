Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYBSKmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYBSKmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYBSKmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:42:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:55224 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYBSKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:42:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Tue, 19 Feb 2008 11:41:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802190101.27429.mb@bu3sch.de> <97a0a9ac0802182059h36d32ac6o841bb0a1b766b74@mail.gmail.com>
In-Reply-To: <97a0a9ac0802182059h36d32ac6o841bb0a1b766b74@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802191141.26952.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 05:59:21 Gordon Farquharson wrote:
> Does this thread [1] provide any clues as to the Right Thing (TM) to do?
> 
> It should be noted that Linus and Andrew signed off on the m68k fix
> [2]. I'm CC'ing them and Al Viro on this email to solicit their input.
> 
> Gordon
> 
> [1] http://www.gossamer-threads.com/lists/linux/kernel/801528
> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff
> 

That doesn't cause me to magically sign off this sort of patches, too.
The sanity check is clearly broken in file2alias.c, as it checks something
from the target kernel against the host environment it is compiled on.
That doesn't make any sense at all.

I also don't see why we want to compare the size of the struct in kernel
and userland. It is not used in userland.

So NACK for this SSB patch.

-- 
Greetings Michael.
