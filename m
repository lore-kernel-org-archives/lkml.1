Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXBOChB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXBOChB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964869AbXBOChA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:37:00 -0500
Received: from fencepost.gnu.org ([199.232.76.164]:40902 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbXBOChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:37:00 -0500
Subject: Two unclear places in lockdep-design.txt
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Feb 2007 21:36:58 -0500
Message-Id: <1171507018.3215.5.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 (2.9.91-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo!

Many thanks for the lockdep validator!  It has helped me immensely.
However, lockdep-design.txt has been pretty hard to read for me.

It would be great if you find an opportunity to clarify two things in
the documentation.

1) What is a lock dependency?  What does "L1 -> L2" mean?  Does it mean
that L1 should be first or second to be acquired?

2) What is "ever held with hardirqs enabled"?  Does it mean that the
lock was used in the code where hardirqs were enabled, or that it _also_
didn't disable hardirqs by itself (e.g. by spin_lock_irq)?  I suspect
the later is the case.

I wish I could submit a patch for the documentation, but I still don't
understand much of the theory.  Still, I was able to interpret the error
messages in a way that allows me to fix the locking issues in some
drivers.

-- 
Regards,
Pavel Roskin

