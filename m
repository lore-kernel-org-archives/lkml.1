Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbXFMSXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbXFMSXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbXFMSXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:23:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760101AbXFMSXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:23:17 -0400
Date: Wed, 13 Jun 2007 14:22:40 -0400
From: Dave Jones <davej@redhat.com>
To: Wang Zhenyu <zhen78@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070613182240.GA3726@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wang Zhenyu <zhen78@gmail.com>, Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>,
	Eric Anholt <eric@anholt.net>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com> <20070613161513.GE3875@redhat.com> <20070613180039.GA4508@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613180039.GA4508@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:00:39AM +0800, Wang Zhenyu wrote:
 > On 2007.06.13 12:15:13 +0000, Dave Jones wrote:
 > >  >     [AGPGART] intel_agp: use table for device probe
 > >  >     
 > > Oh, we have this check in find_gmch ..
 > > 
 > >         if (gmch_device && PCI_FUNC(gmch_device->devfn) != 0) {
 > >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 > > 
 > > Which isn't going to work, as Meelis has a gmch on device0, slot0, devfn1.
 > > Meelis, does it start working again if you change that to just
 > > 
 > > 	if (gmch_Device) {
 > 
 > No, the problem for i815 is that it has a config with no integrated gfx.
 > Sorry I missed it. Meelis, pls test with this patch, which adds a table 
 > item for this, and fixes wrong driver order within origin i815 driver with IGD.

Oops :)
I'll merge this, and get it to Linus today.
Don't forget to add a Signed-off-by: for future patches.

thanks,

	Dave

-- 
http://www.codemonkey.org.uk
