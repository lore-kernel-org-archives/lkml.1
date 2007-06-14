Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbXFNWPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbXFNWPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXFNWJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:09:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbXFNWJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:09:46 -0400
Date: Thu, 14 Jun 2007 18:09:24 -0400
From: Dave Jones <davej@redhat.com>
To: Wang Zhenyu <zhen78@gmail.com>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070614220924.GA8555@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wang Zhenyu <zhen78@gmail.com>, Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Eric Anholt <eric@anholt.net>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com> <20070613161513.GE3875@redhat.com> <20070613180039.GA4508@localhost.localdomain> <20070613182240.GA3726@redhat.com> <20070614013412.GA31534@zhen-devel.sh.intel.com> <20070614020104.GB31534@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614020104.GB31534@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:01:04AM +0800, Wang Zhenyu wrote:
 > On 2007.06.14 09:34:12 +0000, Wang Zhenyu wrote:
 > > 
 > > Dave, after rethinking about this, I think we mixed two cases 
 > > need to be fixed here. This is the patch for this, sorry for mess
 > > it up. Meelis, could you help to test by replace my last patch with this? 
 > > 
 > 
 > oop, for 945GME like case, we should stop scan if still no detection. 
 > Updated patch here. 
 > 
 > [AGPGART] intel_agp: fix device probe
 > 
 > This patch trys to fix device probe in two cases. First we should
 > correctly detect device if integrated graphics device is not enabled
 > or exists, like an add-in card is plugged. Second on some type of intel
 > GMCH, it might have multiple graphic chip models, like 945GME case, so
 > we should be sure the detect works through the whole table.

Applied, though next time, be careful with whitespace..

$ git-applymbox -k ~/agp
1 patch(es) to process.

Applying '[AGPGART] intel_agp: fix device probe'

Adds trailing whitespace.
.dotest/patch:127:                              bridge->driver = 
Space in indent is followed by a tab.
.dotest/patch:133:                              bridge->driver = intel_agp_chipsets[i].driver;
warning: 2 lines add trailing whitespaces.


I fixed it up this time.

	Dave

-- 
http://www.codemonkey.org.uk
