Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0APGpA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237Ab0APGo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:44:59 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:56930 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0APGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:44:58 -0500
Date: Sat, 16 Jan 2010 01:44:44 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Xiaotian Feng <dfeng@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Alexey Starikovskiy <aystarik@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
In-reply-to: <4B3892A1.9010303@suse.de>
Message-id: <alpine.LFD.2.00.1001160143400.10250@localhost.localdomain>
References: <20091210100907.GA2446@ucw.cz>
 <1260446205-16868-1-git-send-email-dfeng@redhat.com>
 <4B20E7B2.1010208@suse.de> <1260510373.10543.17.camel@minggr.sh.intel.com>
 <4B223185.80202@suse.de> <20091211161549.GA15760@elf.ucw.cz>
 <4B227275.5010201@gmail.com> <20091211173424.GC15760@elf.ucw.cz>
 <4B3849F6.1080403@redhat.com> <4B3892A1.9010303@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1255383802-1263624285=:10250"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1255383802-1263624285=:10250
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 28 Dec 2009, Alexey Starikovskiy wrote:

> Xiaotian Feng пишет:

> > What's the status of this now? We can still see the sleeping function
> > call warning or enable irq at resume stage.
> > If acpi wants low latency even for !CONFIG_PREEMPT kernels, what's wrong
> > with V2 patch?
> > 
> > We should not set any preemption points in irq or atomic. Since we have
> > a simple fix, and it did fix bugs, why should
> > we make things more complex?

> We should not do anything complex here, you are right.
> Consider me ACK your patch.

This patch has been in the acpi-test tree for a while
and I'll push it upstream with the next batch.

thanks,
Len Brown, Intel Open Source Technology Center

--8323328-1255383802-1263624285=:10250--
