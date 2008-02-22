Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYBVQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYBVQe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYBVQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:34:09 -0500
Received: from aeryn.cs.uoguelph.ca ([131.104.20.160]:47214 "EHLO
	aeryn.cs.uoguelph.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYBVQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:34:07 -0500
X-Greylist: delayed 1769 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 11:34:06 EST
Date: Fri, 22 Feb 2008 11:01:24 -0500 (EST)
From: Rick Macklem <rick@snowhite.cis.uoguelph.ca>
Message-Id: <200802221601.LAA81388@snowhite.cis.uoguelph.ca>
To: Dan.Muntz@netapp.com
Subject: RE: [PATCH 00/37] Permit filesystem local caching
Cc: casey@schaufler-ca.com, dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       nfsv4@linux-nfs.org, phillips@phunq.net, selinux@tycho.nsa.gov,
       Trond.Myklebust@netapp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, the AFS paper that was referenced earlier was written around the
> time of 10bt and 100bt.  Local disk caching worked well then.  There
> should also be some papers at CITI about disk caching over slower
> connections, and disconnected operation (which should still be
> applicable today).  There are still winners from local disk caching, but
> their numbers have been reduced.  Server load reduction should be a win.
> I'm not sure if it's worth it from a security/manageability standpoint,
> but I haven't looked that closely at David's code.

One area that you might want to look at is WAN performance. When RPC RTT
goes up, ordinary NFS performance goes down. This tends to get overlooked
by the machine room folks. (There are several tools out there that can
introduce delay in an IP packet stream and emulate WAN RTTs.)

Just a thought, rick
