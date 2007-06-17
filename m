Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbXFQUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbXFQUtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXFQUtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:49:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXFQUtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:49:11 -0400
Date: Sun, 17 Jun 2007 16:49:04 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617204904.GB3430@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617195901.GA5689@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 09:59:01PM +0200, Carlo Wood wrote:
 > On Sun, Jun 17, 2007 at 03:07:14PM -0400, Dave Jones wrote:
 > > Sometimes things fall through the cracks..
 > > I haven't heard any similar problems, which makes it somewhat odd.
 > 
 > Ok. Well, the lockup is all to real here :p
 > 
 > I suspect a memory corruption going on, as under certain circumstances
 > there is printed more after the "agpgart: Detected an Intel 965G
 > Chipset." -- that is, the kernel *sometimes* doesn't hang silently,
 > but either reboots by itself (hard reset) or prints something
 > that looks like a total crash to me. Often, this is prefixed by
 > the name of running process. I am sorry, I never wrote any of that
 > down. Only the last time, it then went like:
 > 
 > agpgart: Detected an Intel 965G Chipset.
 > modprobe: Corrupt page table at address 20
 > PGD 178c6c067 PUD 201000c0049c04f BAD

That's pretty bad corruption indeed.  What I'm puzzling over though
is why other 965G users aren't seeing the same thing.
My own 965G seems to be fine, though that's using Intel graphics
instead of nvidia.

(Just to rule it out, I'm assuming at this stage in boot that the
 nvidia driver module has never been loaded?)

And if you never load the agpgart modules, you never see lockups?

Right now, I'm at a loss to explain this.

	Dave

-- 
http://www.codemonkey.org.uk
