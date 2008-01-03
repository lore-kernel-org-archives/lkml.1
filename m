Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYACBQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYACBQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYACBQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:16:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:15059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbYACBQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:16:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="268553440"
Subject: Re: Linux 2.6.23.12
From: Shaohua Li <shaohua.li@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Adam Belay <ambx1@neo.rr.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <200801021342.23763.bjorn.helgaas@hp.com>
References: <20071218224559.GA12696@kroah.com>
	 <20071218224635.GB12696@kroah.com>
	 <200801021342.23763.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 09:16:55 +0800
Message-Id: <1199323015.16091.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 13:42 -0700, Bjorn Helgaas wrote:
> The patch below was put in 2.6.23.12 as a fix for
> http://bugzilla.kernel.org/show_bug.cgi?id=9514.  It apparently
> does make 9514 go away, but only by coincidence.  There are a
> couple other ideas about fixing 9514.  My proposed patch is
> attached in the bugzilla.
> 
> The .12 patch reduces the number of resources we reserve from
> 24 to 8 ioport regions and from 12 to 4 mmio regions per PNP device.
> It also removes a warning about regions we ignore.
> 
> Obviously, we want to reserve ALL the regions for PNP devices,
> and Thomas is working on a patch for that (which I hope will be
> ready for 2.6.25).  But in the meantime, the .12 patch makes it
> more likely that we will have resource conflicts with PNP devices.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9630 appears to be
> such a conflict.
Just let you know why we increase the resource number.
http://bugzilla.kernel.org/show_bug.cgi?id=8973
we found real I/O resource conflict here and cause system hang.

Thanks,
Shaohua

