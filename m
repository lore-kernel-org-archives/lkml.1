Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXCVEAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXCVEAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXCVEAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:00:55 -0400
Received: from mail.kroah.org ([69.55.234.183]:59054 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680AbXCVEAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:00:54 -0400
Date: Wed, 21 Mar 2007 21:00:06 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070322040006.GA6892@suse.de>
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru> <20070322030753.GB5728@suse.de> <20070322035104.GA17159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322035104.GA17159@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 11:51:04PM -0400, Dave Jones wrote:
> On Wed, Mar 21, 2007 at 08:07:53PM -0700, Greg KH wrote:
>  
>  > > After modprobe/rmmod cpufreq/stats directory appears but doesn't get
>  > > removed. Should it?
>  > Well, one can argue that those stats should never be in sysfs at all
>  > anyway, I mean come on, a histogram in sysfs?  That's, not ok.
> 
> Meh, it's only a cheesy debug thing, so it's not really that big a deal imo.
> it could probably move to debugfs (we didn't have that when it was merged iirc)
> I doubt anyone really cares enough to bother though I wouldn't
> be averse to a patch.

Yeah, I realize this, I'm not trying to find fault, sorry if it came
across that way.  And yes, it should move to debugfs some day, but if it
does, I'll loose my "what not to put in sysfs" example I use in
presentations :)

thanks,

greg k-h
