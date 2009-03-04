Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZCDWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZCDWzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCDWz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:55:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:49726 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCDWz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:55:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,303,1233561600"; 
   d="scan'208";a="116840818"
Date: Wed, 4 Mar 2009 14:55:00 -0800
From: Sarah Sharp <sarah.a.sharp@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: EHCI debug documentation
Message-ID: <20090304225500.GB13509@gamba.jf.intel.com>
References: <m1bpshx912.fsf@fess.ebiederm.org> <Pine.LNX.4.44L0.0903041657140.6145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903041657140.6145-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 04:59:28PM -0500, Alan Stern wrote:
> On Wed, 4 Mar 2009, Eric W. Biederman wrote:
> 
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > >> Yinghai Lu wrote:
> > >> > b. netchip USB debug cable
> > >> 
> > >> http://www.plxtech.com/products/NET2000/NET20DC/default.asp
> > >
> > > I have reports that the newer version of this device does not work on
> > > Linux as it isn't enumeratable as a "real" usb device on one end.
> > >
> > > I don't have one of these new devices yet to test it out, has anyone
> > > else heard of this problem?
> > 
> > With the first generation of devices I remember they were peculiar and
> > finicky.  I don't recall the exact details but I remember the devices
> > able to get into weird states that may resemble what you describe.
> 
> Those devices were a little peculiar in that they were powered only on
> one side.  That is, they would take bus power only from the right-hand
> connector (looking at the face with the PLX logo).  So if you plugged
> in only the left side, the device would not show up or enumerate.  But 
> if you plugged in both sides, then both of them would enumerate okay.

That comment should be in the documentation for ehci early printks too.

Sarah Sharp
