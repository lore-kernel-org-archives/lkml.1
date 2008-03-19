Return-Path: <linux-kernel-owner+w=401wt.eu-S942059AbYCSXsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942059AbYCSXsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940116AbYCSWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:16:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762616AbYCSWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:16:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [mmotm] PM build error (PM_SLEEP undef)
Date: Wed, 19 Mar 2008 23:16:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
References: <20080319115703.9cab1103.randy.dunlap@oracle.com>
In-Reply-To: <20080319115703.9cab1103.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192316.03437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Randy Dunlap wrote:
> lots of these when PM_SLEEP not defined: (one example)
> 
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_init_wakeup':
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h:35: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_set_wakeup_enable':
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h:45: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h: In function 'device_may_wakeup':
> mmotm-2008-0318-1720/include/linux/pm_wakeup.h:50: error: 'struct dev_pm_info' has no member named 'should_wakeup'
> make[2]: *** [init/do_mounts.o] Error 1

Fixed patches sent to Greg, hopefully they'll appear in his tree soon.

Thanks,
Rafael
