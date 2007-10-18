Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXJRBme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXJRBme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXJRBm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:42:26 -0400
Received: from ruby.spiritone.com ([216.99.193.130]:37940 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXJRBmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:42:25 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 21:42:25 EDT
Date: Wed, 17 Oct 2007 18:34:16 -0700
Message-Id: <200710180134.l9I1YGBW011092@sapphire.spiritone.com>
From: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Subject: LSM conversion to static interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Like many of us who earn a good living with Linux (for over a decade now) and follow the kernel developer discussions with waxing and waning interest depending on topic, I noticed James Morris' proposal to eliminate the LSM in favor of ordaining SELinux as THE security framework forever and amen, followed by the definitive decision by Linus that LSM would remain.

Well, good, I thought.  Linux should continue to represent freedom for anyone to use basic technology in any way he sees fit.  I turned my attention back to my prosaic day-to-day concerns, thinking that the choice of which security framework to deploy would remain in the hands of the user, regardless of which distributor he chose.

But then I noticed that, while the LSM would remain in existence, it was being closed to out-of-tree security frameworks.  Yikes!  Since then, I've been following the rush to put SMACK, TOMOYO and AppArmor "in-tree". 

Since I know that the people behind these security frameworks are serious and worthy folk of general good repute, I've reluctantly come to the tentative conclusion that the fix is in.  There seem to be powers at work that want LSM closed, and they don't want much public discussion about it.

I think this is bad technology.  I've done due diligence by reviewing the LKML discussion behind closing LSM (and there isn't much).  The technical arguments seem to be (1) some people use the LSM interface for "non-security" purposes, which is frowned upon, (2) it's difficult to properly secure a system with an open-ended interface like LSM, and (3) my security framework should be all any fair-minded person would ever want, so we won't let you use something else.

Exactly. 

Well, any system that permits loading code into "ring 0" can't be made completely secure, so argument 2 reduces to argument 3, which is transparently self-serving (and invalid).

I submit for discussion the idea that a free and open operating system should preserve as much freedom for the end user as possible.  To this end, the kernel should cleanly permit and support the deployment of ANY security framework the end user desires, whether "in-tree" or "out-of-tree".  I agree that any out-of-tree LSM module should be licensed under the GPL (if for no other reason than many current commercial support contracts require non-tainted kernels).

But restricting security frameworks to "in-tree" only is bad technology.

"Freedom" includes the power to do bad things to yourself by, for example, making poor choices in security frameworks.  This possible and permitted end result shouldn't be the concern of kernel developers.  Making configuration and installation of user-chosen frameworks as clean and safe as possible should be.

In my opinion.

Though not sure why, I expect to be scorched by this.  Try not to patronize or condescend.  Give me technical arguments backed by real data.  Show me why a home user or 10,000 node commercial enterprise shouldn't be able to choose what he wants for security without having to jump through your hoops.  Show me why you shouldn't make his use of technology up to him, and as safely and conveniently as you can contrive.

Thanks for a really great operating system, I really love it,

 Tommy F.

