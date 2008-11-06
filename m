Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbYKFCOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbYKFCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYKFCOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:14:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45376 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYKFCOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:14:11 -0500
Date: Thu, 6 Nov 2008 11:13:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       linux-pm@lists.osdl.org, Matt@smtp1.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave@smtp1.linux-foundation.org, Mel Gorman <mel@skynet.ie>,
       Andy@smtp1.linux-foundation.org, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, pavel@suse.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
 hotplug
Message-Id: <20081106111332.8d24a11f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1225936986.6216.23.camel@nigel-laptop>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	<1225817945.12673.602.camel@nimitz>
	<20081105093837.e073c373.kamezawa.hiroyu@jp.fujitsu.com>
	<200811051208.26628.rjw@sisk.pl>
	<20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com>
	<1225931281.11514.27.camel@nimitz>
	<20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
	<1225936986.6216.23.camel@nigel-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 13:03:06 +1100
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi.
> 
> On Thu, 2008-11-06 at 09:53 +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 05 Nov 2008 16:28:01 -0800
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > 
> > > On Thu, 2008-11-06 at 09:14 +0900, KAMEZAWA Hiroyuki wrote:
> > > > Ok, please consider "when memory hotplug happens." 
> > > > 
> > > > In general, it happens when
> > > >   1. memory is inserted to slot.
> > > >   2. the firmware notifes the system to enable already inserted memory.
> > > > 
> > > > To trigger "1", you have to open cover of server/pc. Do you open pc while the system
> > > > starts hibernation ? for usual people, no.
> > > 
> > > You're right, this won't happen very often.  We're trying to close a
> > > theoretical hole that hasn't ever been observed in practice.  But, we
> > > don't exactly leave races in code just because we haven't observed them.
> > > I think this is a classic race.
> > > 
> > > If we don't close it now, then someone doing some really weirdo hotplug
> > > is going to run into it at some point.  Who knows what tomorrow's
> > > hardware/firmware will do?
> > > 
> > Hmm, people tend to make crazy hardware, oh yes. the pc may fly in the sky with rocket engine.
> 
> It doesn't even have to be crazy. Just imagine someone bumping a button
> on the case while plugging in the memory and that button being
> configured to make the machine hibernate.
> 
please don't start hibernation if cover is open....(if you can)

Thanks,
-Kame

