Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbZJVRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbZJVRPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZJVRPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:15:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31832 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZJVRPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:15:46 -0400
Date: Thu, 22 Oct 2009 11:15:50 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
Message-ID: <20091022171550.GC21728@ldl.fc.hp.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> On Wed, 21 Oct 2009, Alex Chiang wrote:
> 
> > Hi Greg, Randy,
> > 
> > Not sure who actually maintains Documentation/ABI/; if it's not either of
> > y'all then please point me at the correct maintainer.
> > 
> > Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel.mm/40084/
> > 
> > I documented my changes, but David Rientjes suggested that I take this
> > as an opportunity to do a more thorough job, so here is an attempt at
> > doing so by documenting at least the files that I saw on my system. Maybe
> > there are more that I didn't configure in, but I think this series covers
> > a good amount.
> > 
> 
> Fantastic, thanks Alex!
> 
> One thing I noticed in patches 3-6 of this series is you've attached 
> multiple files to a single "What:" line.  That hasn't been done before 
> (ignore the style violations of sysfs-firmware-*) and I think it would be 
> better to seperate each file out into its own section.

Ok, I can do that.

I was originally going for compactness, but I understand the
point you make below.

> I know it's long, but I think some automated scripts are eventually going 
> to use this documentation and it's best to follow the guidelines in 
> Documentation/ABI/README.

What do you think about keeping all the descriptions in the same
file, sysfs-devices-system-cpu vs. splitting them out into
separate files, sysfs-devices-system-cpu-topology, e.g.?

Will your tools be able to handle that?

Thanks.
/ac

