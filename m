Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbXKOXip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbXKOXip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934000AbXKOXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:38:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46822 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbXKOXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:38:29 -0500
Date: Thu, 15 Nov 2007 15:38:17 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071115233817.GD5928@us.ibm.com>
References: <20071115004039.GC6269@us.ibm.com> <20071115173613.GG7541@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115173613.GG7541@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 10:36:13AM -0700, Alex Chiang wrote:
  < snip >

> Ok, so all that said, after re-implementing my ACPI-PCI slot
> driver, we get all the correct answers, but with the additional
> appearance of slots 1 and 2 (which aren't hotpluggable):

Yea, looks much better.  Nice to see that the addresses
for slots below the p2p bridges now include the child
instead of the parent bus number. :)

  < snip >

> So if you could try out v2 of my patch series when you get access
> to your machine back, I'd much appreciate it. 

Will do.  It still looks like I will not get the box back
until early next week.  I will only be working Monday and
Tuesday due to holiday/vacation but that will hopefully not
be a problem.

> I feel a lot better about it compared to v1.

I haven't tried it yet but I feel better seeing that you
are now testing on a system having a PCI topology that
appears similar to some of our systems.

  < snip >

> Here is some dmesg and lspci -vt output in case you want to
> double-check my work:

Well, I didn't see any obvious warts but I'm pretty skilled
at missing problems when looking at that kind of info.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

