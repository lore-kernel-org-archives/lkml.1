Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYAHXzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYAHXzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYAHXzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:55:08 -0500
Received: from ns.suse.de ([195.135.220.2]:34760 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYAHXzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:55:06 -0500
Date: Tue, 8 Jan 2008 15:58:46 -0800
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Message-ID: <20080108235846.GA17067@suse.de>
References: <20080106161128.152634000@chello.nl> <1199703080.7143.24.camel@twins> <20080107122330.GB25945@linux.vnet.ibm.com> <1199725063.31975.53.camel@lappy> <20080108105733.GA2569@linux.vnet.ibm.com> <1199790150.7143.57.camel@twins> <3ae72650801080631p2b2c50a6q3d59badf06b62684@mail.gmail.com> <1199835332.31975.66.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199835332.31975.66.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 12:35:32AM +0100, Peter Zijlstra wrote:
> 
> On Tue, 2008-01-08 at 15:31 +0100, Kay Sievers wrote:
> > On Jan 8, 2008 12:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > On Tue, 2008-01-08 at 16:27 +0530, Dhaval Giani wrote:
> > > > On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> > > > >
> > > > > Subject: sched: rt-group: add uid-group interface
> > > > >
> > > > > Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> > > > > the group's rt_period and rt_runtime.
> > > > >
> > > >
> > > > Hi Peter,
> > > >
> > > > Cool stuff! I will try out these patches and try to give you some
> > > > feedback.
> > >
> > > Thanks, much appreciated!
> > >
> > > > One request though, could you please add some documentation to
> > > > Documentation/ABI/testing/sysfs-kernel-uids?
> > >
> > > I already have documentation on the todo list, I'll add this file to
> > > that list :-)
> > 
> > Care to rebase the patch against -mm, we fixed the mixed-up usage
> > of ksets and kobjects, and this can not apply anymore:
> >   http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/struct-user_info-sysfs.patch;hb=HEAD
> > 
> > There is also an attribute group now which makes it much easier to add
> > new files.
> 
> Ingo, Greg,
> 
> What would be the easiest way to carry this forward? sched-devel and
> greg's tree would intersect at this point and leave poor akpm with the
> resulting mess. Should I just make an incremental patch akpm can carry
> and push? Or can we base one tree off the other?

If it's just a single patch for this, I'd be glad to take it.  But by
looking at the [11/12] above, I doubt this is so...

If it's not that rough (12 patches is not a big deal), I'd be glad to
take these through my tree, after you fix up Kay's requests above :)

thanks,

greg k-h
