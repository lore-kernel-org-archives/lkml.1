Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYCTEU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYCTEU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYCTEUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:20:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42711 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYCTEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:20:44 -0400
Date: Wed, 19 Mar 2008 21:19:56 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [mmotm] PM build error (PM_SLEEP undef)
Message-ID: <20080320041956.GF26232@kroah.com>
References: <20080319115703.9cab1103.randy.dunlap@oracle.com> <200803192316.03437.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803192316.03437.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 11:16:02PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Randy Dunlap wrote:
> > lots of these when PM_SLEEP not defined: (one example)
> > 
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_init_wakeup':
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h:35: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_set_wakeup_enable':
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h:45: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_may_wakeup':
> > mmotm-2008-0318-1720/include/linux/pm_wakeup.h:50: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> > make[2]: *** [init/do_mounts.o] Error 1
> 
> Fixed patches sent to Greg, hopefully they'll appear in his tree soon.

Ah, ok, I'll catch up on my patch queue tomorrow, been away this week...

thanks,

greg k-h
