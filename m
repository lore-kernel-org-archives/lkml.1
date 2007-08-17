Return-Path: <linux-kernel-owner+w=401wt.eu-S1764953AbXHQOcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764953AbXHQOcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXHQObt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:31:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764136AbXHQOb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:31:26 -0400
Date: Fri, 17 Aug 2007 10:31:19 -0400
From: Dave Jones <davej@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Susanne Oberhauser <froh@novell.com>, Jan Blunck <jblunck@suse.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       opensuse-kernel@opensuse.org, opensuse@opensuse.org
Subject: Re: Testing the Current Upstream Kernel
Message-ID: <20070817143119.GB13008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
	Susanne Oberhauser <froh@novell.com>, Jan Blunck <jblunck@suse.de>,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	opensuse-kernel@opensuse.org, opensuse@opensuse.org
References: <s2ihcn1vwob.fsf@totally-fudged-out-message-id> <s2iwsvvlqnh.fsf@byron.suse.de> <6891.1187273061@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6891.1187273061@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 10:04:21AM -0400, Valdis.Kletnieks@vt.edu wrote:
 > On Thu, 16 Aug 2007 12:28:34 +0200, Susanne Oberhauser said:
 > > Jan Blunck <jblunck@suse.de> writes:
 > > 
 > > > With our openSUSE Build Service we build a daily kernel, where we take
 > > > nightly snapshots of the current upstream development kernel (Linus' kernel
 > > > tree linux-2.6.git) without any patches (besides those we need for building a
 > > > RPM).  We do call this the vanilla kernel. It can be downloaded from:
 > > > 
 > > >  http://download.opensuse.org/repositories/Kernel:/Vanilla/SUSE_Factory/
 > > 
 > > Would it make sense to build it for the other distros as well?  like
 > > debian, fedora and mandrake?  I mena in _theory_ we could build it for
 > > those distros in the build server, couldn't we?
 > 
 > Most of the distros prefer a chance to add their own "Special Sauce" to it
 > before building, and building inside their build environment (for instance,
 > Fedora RPM's get PGP-signed - *that* would be a trust issue right there).
 > 
 > The current Fedora Rawhide kernel is 'kernel-2.6.23-0.105.rc3.fc8', and a few
 > RPMs ago it was based against -rc2-git5, so they track *very* close.  I think
 > that crew is managing well enough without help from the kernel.org build
 > server.

FWIW, you've been able to build the Fedora SRPMs with --with-vanilla
for a while now, which generates an RPM with no patches at all other
than the -rc/-git on which its based.
We're trying to work out logistics of which repository etc we're
going to host this in, but soon we'll be able to just offer
'yum install kernel-vanilla' to users.

	Dave

-- 
http://www.codemonkey.org.uk
