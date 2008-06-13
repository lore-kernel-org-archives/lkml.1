Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYFMBBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYFMBBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYFMBB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:01:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:62032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833AbYFMBB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,634,1204531200"; 
   d="scan'208";a="259115170"
Subject: Re: [PATCH -mm 1/2] kexec jump -v11: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080612192015.GH9654@redhat.com>
References: <1213082104.22608.29.camel@caritas-dev.intel.com>
	 <20080612192015.GH9654@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 09:04:00 +0800
Message-Id: <1213319040.20431.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 13 Jun 2008 01:01:19.0654 (UTC) FILETIME=[FD746460:01C8CCF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 15:20 -0400, Vivek Goyal wrote:
> On Tue, Jun 10, 2008 at 03:15:04PM +0800, Huang, Ying wrote:
> > This patch provides an enhancement to kexec/kdump. It implements
> > the following features:
> > 
> > - Backup/restore memory used by the original kernel before/after
> >   kexec.
> > 
> > - Save/restore CPU state before/after kexec.
> > 
> > The features of this patch can be used as a general method to call
> > program in physical mode (paging turning off). This can be used to
> > call BIOS code under Linux.
> > 
> > 
> 
> Hi Huang,
> 
> I was testing these patches and I get following error on my machine.
> 
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> Suspending console(s) (use no_console_suspend to debug)
> PM: Device i8042 failed to freeze: error -22
> Restarting tasks ... done.
> 
> Any idea why keyboard controller would not freeze?

Which kernel version do you use?

Does original hibernation work? It can be setup easily. Just add
following parameters to kernel command line:

resume=/dev/<xxx>

Where <xxx> is the swap partition.

And execute following command:

echo reboot > /sys/power/disk
echo disk > /sys/power/state

Best Regards,
Huang Ying

