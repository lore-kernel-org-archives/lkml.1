Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYBVQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYBVQvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbYBVQv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:51:27 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYBVQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:51:25 -0500
Date: Fri, 22 Feb 2008 08:50:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off
 aftersuspend-to-disk. Screen becomes green.
In-Reply-To: <20080222130615.GA29123@elte.hu>
Message-ID: <alpine.LFD.1.00.0802220843560.19896@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com> <200802211623.55450.jesse.barnes@intel.com> <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com>
 <20080222103727.GA25781@srcf.ucam.org> <20080222130615.GA29123@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Feb 2008, Ingo Molnar wrote:
> 
> btw., why isnt there an in-kernel whitelist, with perhaps a dynamic, 
> convenient /debug/s2r/whitelist append-API for distros (and testers) to 
> add more entries to the whitelist/blacklist? (for cases where the kernel 
> whitelist has not caught up yet) Which would eventually converge to 
> Utopia: s2ram that just works out of box.

The big problem with that is
 - the people who know about the devices are usually not kernel people
 - the workarounds that the whitelist requires is quite often not a kernel 
   workaround.

In other words, the most common workarounds for the s2ram whitelist is 
usually to do things like running vbetool in user-level to do VGA register 
save/restore (VBE_POST and VGE_SAVE). Sure, the kernel could do that with 
usermodehelper etc, but s2ram also has those things as command line flags 
etc, so...

		Linus
