Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0BVX7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:59:02 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:55992 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0BVX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:59:00 -0500
X-Greylist: delayed 2508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2010 18:59:00 EST
Message-ID: <4B83106C.7040203@cs.columbia.edu>
Date: Mon, 22 Feb 2010 18:17:00 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux-Containers <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Linux Checkpoint-Restart - v19
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

We've put a stake in the ground for our next set of checkpoint/restart
patches, v19. It has some great new stuff, and we put extra effort to
address your concerns. We would like to have the code included in -mm
for wider feedback and testing.

This one is able to checkpoint/restart screen and vnc sessions, and
live-migrate network servers between hosts. It also adds support for
x86-64 (in addition to x86-32, s390x and powerpc). It is rebased to
kernel 2.6.33-rc8.

Since one of your main concerns was about what is not yet implemented
and how complicated or ugly it will be to support that, we've put up
a wiki page to address that. In it there is a simple table that lists
what is not implemented and the anticipated solution impact, and for
some entries a link to more details.

The page is here:   http://ckpt.wiki.kernel.org/index.php/Checklist

We want to stress that the patchset is already very useful as-is. We
will keep working to implement more features cleanly. Some features we
are working on include network namespaces and device configurations,
mounts and mounts namespaces, and file locks. Should a complicated
feature prove hard to implement, users have alternatives systems like
kvm, until we manage to come up with a clean solution.

We believe that maintenance is best addressed through testing. We now
have a comprehensive test-suite to automatically find regressions.
In addition, we ran LTP and the results are the same with CHECKPOINT=n
and =y.

If desired we'll send the whole patchset to lkml, but the git trees
can be seen at:

   kernel:       http://www.linux-cr.org/git/?p=linux-cr.git;a=summary
   user tools:   http://www.linux-cr.org/git/?p=user-cr.git;a=summary
   tests suite:  http://www.linux-cr.org/git/?p=tests-cr.git;a=summary

Thanks,

Application checkpoint/restart team
