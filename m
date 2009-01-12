Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZALRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZALRxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZALRxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:53:22 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32294 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZALRxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:53:21 -0500
X-BigFish: VPS-45(zz1432R62a3L98dR936eQ1805M936fO3117Kzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KDDDOB-02-Y7O-01
Date: Mon, 12 Jan 2009 18:52:44 +0100
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
	IBM Cell processor
Message-ID: <20090112175244.GJ15411@erda.amd.com>
References: <1228177106.6509.285.camel@carll-linux-desktop> <20090108154835.GQ15411@erda.amd.com> <1231460791.6621.54.camel@carll-linux-desktop> <1231630269.2142.91.camel@pasglop> <1231776927.6621.112.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1231776927.6621.112.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jan 2009 17:52:44.0941 (UTC) FILETIME=[92B113D0:01C974DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.09 08:15:27, Carl Love wrote:
> 
> On Sun, 2009-01-11 at 10:31 +1100, Benjamin Herrenschmidt wrote:
> > On Thu, 2009-01-08 at 16:26 -0800, Carl Love wrote:
> > > I pulled down the git tree, compiled and installed it.  I tested it
> > > against the OProfile testsuite, which includes SPU event profiling
> > > tests.  Everything passed.  The patch I submitted was against a 2.6.26
> > > tree.  You are now on a 2.6.28 tree so perhaps that is why the patch did
> > > not apply cleanly.  The patch has been out there for some time.  
> > 
> > When you submited it on Dec 2, it should have been against whatever was
> > the latest upstream at the time, not 2.6.26.
> > 
> > Cheers,
> > Ben.
> 
> Ben, Arnd and Robert:
> 
> The patch was against the latest Arnd Cell Kernel tree at the time it
> was posted. The OProfile for cell patches have all been submitted,
> accepted by Arnd (CELL Kernel maintainer) and pushed up stream by Arnd.
> Arnd has waited for the OProfile maintainer to review and approve the
> change before Arnd would push it upstream.  

The patches are already upstream in v2.6.29-rc1. Hope this is ok. I
had added them to the oprofile tree and the tree was merged be Linus.

-Robert

> So, at this point, Robert's (OProfile kernel maintainer) and Maynard's
> (OProfile user space maintainer) approval for the patches.  
> 
> The question now goes to Arnd and Robert, who is going to push the
> patches upstream?  Looks like Robert is ready to do it, so Arnd do you
> approve the patches?  Would you like to have Robert push the patches
> upstream or would you prefer to do it?  I think we need an
> answer/agreement on this.  

Arnd, I thought the patches were ok for you. If there are still some
concerns, we have to make delta patches.

See also here:

 git log -4 -p 25006644e6042aab4bb7cdc4bfc5777cd3141df7

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

