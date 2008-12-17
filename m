Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751513AbYLQDy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbYLQDy1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYLQDyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:54:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYLQDyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:54:15 -0500
Date: Tue, 16 Dec 2008 22:53:16 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>, Jeff Arnold <jbarnold@MIT.EDU>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH 0/7] Ksplice: Rebootless kernel updates
Message-ID: <20081217035316.GA24620@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tim Abbott <tabbott@MIT.EDU>, Jeff Arnold <jbarnold@MIT.EDU>,
	linux-kernel@vger.kernel.org,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Ben Collins <bcollins@ubuntu.com>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu> <20081216190740.9db323ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216190740.9db323ee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 07:07:40PM -0800, Andrew Morton wrote:

 > I'd have _thought_ that distros and their high-end customers would be
 > interested in it, but I haven't noticed anything from them.  Not that
 > this means much - our processes for gathering this sort of information
 > are rudimentary at best.  Has your team been in contact with distros?
 > Are Suse shipping it, or planning to?
 > 
 > (cc's a few more distro people)

I'm not exactly enamoured by this tbh.
It's a neat hack, but the idea of it being used by even a small percentage
of our users gives me the creeps.
 
It comes down to 'what happens when something goes wrong'.
When the end-user is running a ksplice-patched kernel with an unknown
number of patches, reproducability can get really complicated.
The Fedora position on it has been 'you keep both pieces if something breaks'
in the same way we don't support someone who hand-built their own kernel.
I understand ksplice now taints the kernel when it applies a patch, which
is a step in the right direction, but we don't always get to see
tainted flags in bug reports (the non-oops variants for eg).

If distros can't get security updates out in a reasonable time, fix
the process instead of adding mechanism that does an end-run around it.

Which just leaves the "we can't afford downtime" argument, which leads
me to question how well reviewed runtime patches are.

Having seen some of the non-ksplice runtime patches that appear in the
wake of a new security hole, I can't say I have a lot of faith.
Perhaps if there was a kernel.org sanctioned ksplice functionality, 
then such patches would get better review before being deployed. Dunno.

	Dave

-- 
http://www.codemonkey.org.uk
