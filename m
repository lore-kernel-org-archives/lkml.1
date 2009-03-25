Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZCZAxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZCZAxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZCZAwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:52:54 -0400
Received: from hq2.tensilica.com ([65.205.227.30]:5442 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751070AbZCZAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:52:53 -0400
X-Greylist: delayed 3101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 20:52:51 EDT
Message-ID: <49CAC578.5000208@tensilica.com>
Date: Wed, 25 Mar 2009 16:59:52 -0700
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-xtensa@linux-xtensa.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
       Marc Gauthier <marc@tensilica.com>
CC: Johannes Weiner <jw@emlix.com>,
       =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>,
       Piet Delaney <piet.delaney@tensilica.com>, piet.delaney@gmail.com
Subject: [XTENSA] - Updated 2.6.27-smp with changes needed for SMP stabilization
 and New Xtensa V3 MMU
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated 2.6.27-SMP at http://linux-xtensa.org/ with changes needed to stabilize
SMP. This work was started by Chris Zankel. Joe Taylor integrated Chris's changes
and started stabilizing them for the caches without alias problems. I finished the
SMP stabilization, including systems with cache alias problems. Marc Gauthier and
I have fixed and improved the exception processing and added support for the
Tensilica's new V3 MMU (currently in pre-alpha testing). We have made the context
of an exception is now visible on the stack, similar to other architectures.

This kernel has been tested with our latest buildroot changes and is much more
stable. We do seem to experience problems after about a week of LTP testing. I've
added gdb macros to display the back-traces of the linux tasks to root-cause this problem.
These macros are provided in the new Xtnesa Documentation directory. I've started KGDB
integration but need to use ISS simulations to root cause the problems showing up in
it's early startup self-check.

I'd appreciate hearing feedback on these changes in preparation for integration with
the mainstream kernel. I'm currently merging with the git repository provided by the
developers at Emlix and hope to have it running and posted to http://linux-xtensa.org
shortly as well as a linux-next repo worthy of being pulled by Chris.

I've just updated my xtensa-2.6.27-smp git repository on hera.

     git://git.kernel.org/pub/scm/linux/kernel/git/piet/xtensa-2.6.27-smp.git

it should be available on the git server shortly.


At Tensilica it's available at:

     git://git.linux-xtensa.org/git/kernel/xtensa-2.6.27-smp

I've upgraded our latest changes to master now that's it's vary stable.

-piet




