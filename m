Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXFQVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXFQVeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFQVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:34:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbXFQVeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:34:02 -0400
Date: Sun, 17 Jun 2007 17:33:55 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617213355.GC3430@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617211338.GA24771@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 11:13:38PM +0200, Carlo Wood wrote:
 > On Sun, Jun 17, 2007 at 04:49:04PM -0400, Dave Jones wrote:
 > > That's pretty bad corruption indeed.  What I'm puzzling over though
 > > is why other 965G users aren't seeing the same thing.
 > > My own 965G seems to be fine, though that's using Intel graphics
 > > instead of nvidia.
 > > 
 > > (Just to rule it out, I'm assuming at this stage in boot that the
 > >  nvidia driver module has never been loaded?)
 > 
 > Doesn't even exist for that kernel. I only compiled a new
 > nvidia driver module for one kernel - the one that I am using
 > on a daily basis.
 > 
 > > And if you never load the agpgart modules, you never see lockups?
 > 
 > What would the name be of such module?

intel-agp

Though by the looks of things, with the working kernel, you don't have
it loaded (it's dependant upon the 'agpgart' module, which prints the
"Detected" line that was missing).

	Dave

-- 
http://www.codemonkey.org.uk
