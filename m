Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXFQTHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXFQTHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXFQTH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:07:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100AbXFQTH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:07:26 -0400
Date: Sun, 17 Jun 2007 15:07:14 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617190714.GA18115@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617162235.GA5486@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 06:22:35PM +0200, Carlo Wood wrote:

 > > Hi Dave, I have an amd64 box for which every kernel
 > > after 2.6.18 hangs during boot, so I have no dmesg :(
 > > 
 > > I used git bisect to find out where the problem patch is,
 > > and assuming bisect works (imho it jumped between versions
 > > very weirdly: closing in on the last 6 revisions, it
 > > jumped from 2.6.18 to 2.6.18-rc2 to 2.6.18-rc6), the problem
 > > is a patch in intel-agp.c, where support for the intel 965G
 > > is added (which I have).
 > Dave, I have no idea why you never replied to this -- don't
 > you care that kernels 2.6.19 through 2.6.21 lockup on boot? --

Sometimes things fall through the cracks..
I haven't heard any similar problems, which makes it somewhat odd.

 > The patch causes my machine to lock up and/or crash
 > in various ways (depending on the exact version of the kernel),
 > very shortly after printing: agpgart: Detected an Intel 965G Chipset.
 > 
 > The first kernel version that stops doing that is 2.6.22-rc5.
 > I used git bisect once more to find the patch that fixes this bug:
 > I am mailing this mostly because the comment doesn't seem to indicate
 > that the author is aware that this patch fixes an existing regression
 > (it worked fine for me with 2.6.18).

Indeed, it was unknown to me too, this should have just been
a clean-up.

 > If anyone wants to know more (like what hardware I'm using), please
 > show me that you're actually alive / reading my mails.

Out of curiousity, I'd like to see your lspci
(not -v or anything, just run with no args)

	Dave


-- 
http://www.codemonkey.org.uk
