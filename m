Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbZLPEdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbZLPEdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbZLPEdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:33:10 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:46861 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZLPEdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:33:09 -0500
Date: Tue, 15 Dec 2009 23:32:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 -v2] acpi, apei, Document for APEI
In-reply-to: <1260780295.12561.118.camel@yhuang-dev.sh.intel.com>
Message-id: <alpine.LFD.2.00.0912152322110.6885@localhost.localdomain>
References: <1260429424.15264.397.camel@yhuang-dev.sh.intel.com>
 <200912110958.29319.bjorn.helgaas@hp.com>
 <1260780295.12561.118.camel@yhuang-dev.sh.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009, Huang Ying wrote:

> On Sat, 2009-12-12 at 00:58 +0800, Bjorn Helgaas wrote: 
> > On Thursday 10 December 2009 12:17:04 am Huang Ying wrote:
> > > Add document for APEI, including kernel parameters and EINJ debug file
> > > sytem interface.
> > 
> > From a stylistic point of view, I think it's better if the
> > documentation is added by the same patch that adds the functionality.
> > Having them in separate patches means there's a point in time where
> > the tree contains the functionality but not the documentation, or
> > vice versa.
> 
> Sounds reasonable, I will change this.

I don't mind if the documentation preceeds or follows the code
in a patch series.  Personally, I'd probably put it in its own
patch like you did just as a lazy way to keep the patches small.
Anybody looking at this code will be looking at the whole series
and it isn't as if documentation is going to break bisect...

What I do mind from a patch submitting style point of view
is to start a series with [PATCH 2/5 -v2].

Please start with 0/5 explaining the difference between v1 and v2;
and then number staring with 1, not 2; else at first glance,
everybody thinks that the most important patch is missing...

That said, all this code is under its own config option,
making it relatively low risk.  The question is if there
would be a significant benefit to merging this code upstream
while we know there is still going to be some significant
movement in this area before it is fully baked...

(that would be another thing to describe in 0/5...)

thanks,
-Len Brown, Intel Open Source Technology Center
