Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXCVDYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXCVDYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCVDYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:24:11 -0400
Received: from mail.kroah.org ([69.55.234.183]:55860 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626AbXCVDYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:24:10 -0400
Date: Wed, 21 Mar 2007 20:07:53 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, akpm@osdl.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070322030753.GB5728@suse.de>
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320100634.GA6811@localhost.sw.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 01:06:34PM +0300, Alexey Dobriyan wrote:
> On Mon, Mar 19, 2007 at 01:41:25PM -0700, Greg KH wrote:
> > On Mon, Mar 19, 2007 at 06:30:13PM +0300, Alexey Dobriyan wrote:
> > > Steps to reproduce:
> > >
> > > 	# modprobe p4-clockmod
> > > 	$ cd /sys/devices/system/cpu/cpu0/cpufreq/
> > > 	# rmmod p4-clockmod
> > > 	$ cat stats/time_in_state
> > > 	Segmentation fault
> >
> > Has this always happened?  Or is it new?
> 
> I've checked 2.6.17 and up and it happens too.
> 
> Some .config peculiarities:
> 
> 	CONFIG_CPU_FREQ=y
> 	CONFIG_CPU_FREQ_STAT=y
> 	CONFIG_X86_P4_CLOCKMOD=m
> 
> After modprobe/rmmod cpufreq/stats directory appears but doesn't get
> removed. Should it?

Yes.

Well, one can argue that those stats should never be in sysfs at all
anyway, I mean come on, a histogram in sysfs?  That's, not ok.

thanks,

greg k-h
