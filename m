Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXCVELc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXCVELc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXCVELc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:11:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654AbXCVELb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:11:31 -0400
Date: Wed, 21 Mar 2007 20:10:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-Id: <20070321201042.f1cbf4d8.akpm@linux-foundation.org>
In-Reply-To: <20070322040006.GA6892@suse.de>
References: <20070319153013.GA6814@localhost.sw.ru>
	<20070319204125.GA5598@suse.de>
	<20070320100634.GA6811@localhost.sw.ru>
	<20070322030753.GB5728@suse.de>
	<20070322035104.GA17159@redhat.com>
	<20070322040006.GA6892@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 21:00:06 -0700 Greg KH <gregkh@suse.de> wrote:

> On Wed, Mar 21, 2007 at 11:51:04PM -0400, Dave Jones wrote:
> > On Wed, Mar 21, 2007 at 08:07:53PM -0700, Greg KH wrote:
> >  
> >  > > After modprobe/rmmod cpufreq/stats directory appears but doesn't get
> >  > > removed. Should it?
> >  > Well, one can argue that those stats should never be in sysfs at all
> >  > anyway, I mean come on, a histogram in sysfs?  That's, not ok.
> > 
> > Meh, it's only a cheesy debug thing, so it's not really that big a deal imo.
> > it could probably move to debugfs (we didn't have that when it was merged iirc)
> > I doubt anyone really cares enough to bother though I wouldn't
> > be averse to a patch.
> 
> Yeah, I realize this, I'm not trying to find fault, sorry if it came
> across that way.  And yes, it should move to debugfs some day, but if it
> does, I'll loose my "what not to put in sysfs" example I use in
> presentations :)
> 

I ain't picky, but as a short-term thing it'd be kinda nice if it didn't
oops the kernel.
