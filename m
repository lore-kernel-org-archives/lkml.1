Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYBGERz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYBGERz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 23:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYBGERr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 23:17:47 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:57704 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbYBGERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 23:17:46 -0500
Date: Thu, 7 Feb 2008 09:47:22 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kay Sievers <kay.sievers@vrfy.org>, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Message-ID: <20080207041721.GA11520@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1199703080.7143.24.camel@twins> <20080107122330.GB25945@linux.vnet.ibm.com> <1199725063.31975.53.camel@lappy> <20080108105733.GA2569@linux.vnet.ibm.com> <1199790150.7143.57.camel@twins> <3ae72650801080631p2b2c50a6q3d59badf06b62684@mail.gmail.com> <1199835332.31975.66.camel@lappy> <20080108235846.GA17067@suse.de> <20080108235750.GA27248@elte.hu> <20080110000531.GA18069@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110000531.GA18069@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 04:05:31PM -0800, Greg KH wrote:
> > > > Ingo, Greg,
> > > > 
> > > > What would be the easiest way to carry this forward? sched-devel and
> > > > greg's tree would intersect at this point and leave poor akpm with the
> > > > resulting mess. Should I just make an incremental patch akpm can carry
> > > > and push? Or can we base one tree off the other?
> > > 
> > > If it's just a single patch for this, I'd be glad to take it.  But by 
> > > looking at the [11/12] above, I doubt this is so...
> > > 
> > > If it's not that rough (12 patches is not a big deal), I'd be glad to 
> > > take these through my tree, after you fix up Kay's requests above :)
> > 
> > hm, i'd really like to see this tested and go through sched.git. It's 
> > only the few sysfs bits which interfere, right?
> 
> Yes, that should be it.
> 
> So why not put the majority of this through sched.git, then when my
> sysfs changes go in at the beginning of the .25 merge cycle, you can
> then add the sysfs changes through your tree or anywhere else.
> 

Hi,

I was wondering where these changes are right now. I don't see the sysfs
interface for rt-group-sched in mainline right now.

Thanks,
-- 
regards,
Dhaval
