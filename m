Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYKFCDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYKFCDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYKFCDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:03:15 -0500
Received: from mail.crca.org.au ([67.207.131.56]:45872 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbYKFCDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:03:14 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Nigel Cunningham <ncunningham@crca.org.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       linux-pm@lists.osdl.org, Matt@smtp1.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave@smtp1.linux-foundation.org, Mel Gorman <mel@skynet.ie>,
       Andy@smtp1.linux-foundation.org, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, pavel@suse.cz,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <1225817945.12673.602.camel@nimitz>
	 <20081105093837.e073c373.kamezawa.hiroyu@jp.fujitsu.com>
	 <200811051208.26628.rjw@sisk.pl>
	 <20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com>
	 <1225931281.11514.27.camel@nimitz>
	 <20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Thu, 06 Nov 2008 13:03:06 +1100
Message-Id: <1225936986.6216.23.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-11-06 at 09:53 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 05 Nov 2008 16:28:01 -0800
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 2008-11-06 at 09:14 +0900, KAMEZAWA Hiroyuki wrote:
> > > Ok, please consider "when memory hotplug happens." 
> > > 
> > > In general, it happens when
> > >   1. memory is inserted to slot.
> > >   2. the firmware notifes the system to enable already inserted memory.
> > > 
> > > To trigger "1", you have to open cover of server/pc. Do you open pc while the system
> > > starts hibernation ? for usual people, no.
> > 
> > You're right, this won't happen very often.  We're trying to close a
> > theoretical hole that hasn't ever been observed in practice.  But, we
> > don't exactly leave races in code just because we haven't observed them.
> > I think this is a classic race.
> > 
> > If we don't close it now, then someone doing some really weirdo hotplug
> > is going to run into it at some point.  Who knows what tomorrow's
> > hardware/firmware will do?
> > 
> Hmm, people tend to make crazy hardware, oh yes. the pc may fly in the sky with rocket engine.

It doesn't even have to be crazy. Just imagine someone bumping a button
on the case while plugging in the memory and that button being
configured to make the machine hibernate.

Regards,

Nigel

