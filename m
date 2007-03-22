Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXCVDwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXCVDwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXCVDwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:52:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXCVDv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:51:59 -0400
Date: Wed, 21 Mar 2007 23:51:04 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070322035104.GA17159@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
	akpm@osdl.org
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru> <20070322030753.GB5728@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322030753.GB5728@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 08:07:53PM -0700, Greg KH wrote:
 
 > > After modprobe/rmmod cpufreq/stats directory appears but doesn't get
 > > removed. Should it?
 > Well, one can argue that those stats should never be in sysfs at all
 > anyway, I mean come on, a histogram in sysfs?  That's, not ok.

Meh, it's only a cheesy debug thing, so it's not really that big a deal imo.
it could probably move to debugfs (we didn't have that when it was merged iirc)
I doubt anyone really cares enough to bother though I wouldn't
be averse to a patch.
To the best of my knowledge, nothing in userspace is relying on that stuff
being present (it'd have to cope with it not being there anyway given its
optional).

	Dave

-- 
http://www.codemonkey.org.uk
