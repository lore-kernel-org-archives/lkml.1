Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXEVSyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXEVSyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbXEVSyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:54:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbXEVSyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:54:00 -0400
Date: Tue, 22 May 2007 14:53:53 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the -stable cycle
Message-ID: <20070522185353.GE12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chris Wright <chrisw@sous-sol.org>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522184733.GA9357@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:47:33AM -0700, Greg Kroah-Hartman wrote:
 > On Tue, May 22, 2007 at 02:14:44PM -0400, Chuck Ebbert wrote:
 > > I'd like to propose we allow adding new device IDs as part
 > > of the -stable process, but only under certain conditions:
 > 
 > Who would be the primary benifactor of this?
 > 
 > The very large majority of users out there use a distro kernel, and they
 > provide the ids whenever possible as patches to their kernels, _or_ as a
 > config option at startup that adds the ids to the drivers through sysfs.

It does mean however that there's lots of duplicated work between
distros as everyone adds these patches anyway.

 > What's wrong with the current sysfs way of adding new device ids without
 > touching the kernel?

sure, that works in some cases, but for others (quirks etc) it obviously doesn't.

 > > http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=823777181b4c0200923dcb026efa5b37f55c0ecf
 > > 
 > > Adds ATI sb700 quirk, using exactly the same one as sb600.
 > 
 > That's a quirk addition, not a new device id following the above
 > mentioned rules you set out :)

Right, but adding the quirk alone would be pointless with the ID.
This is a case where 'use sysfs' doesn't work.

	Dave

-- 
http://www.codemonkey.org.uk
