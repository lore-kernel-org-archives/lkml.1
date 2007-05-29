Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbXE2OWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbXE2OWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXE2OWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:22:42 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:34967 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbXE2OWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:22:41 -0400
Date: Tue, 29 May 2007 16:22:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070529142222.GC18437@osiris.boeblingen.de.ibm.com>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <20070529115324.GB18437@osiris.boeblingen.de.ibm.com> <20070529131903.GA5024@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529131903.GA5024@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Possible further checks that might make sense:
> > > - panic() anywhere in drivers/* 
> > 
> > A driver should be allowed to panic. E.g. if it detects that due to a
> > firmware or driver bug memory corruption happened. IMHO the best thing
> > to do then is panic.
> 
> That is not how Linux normally operates. A BUG() doesn't panic() by
> default either.
> 
> And on systems with IOMMU that is exactly the wrong thing to do.
> 
> Besides the problem is that bad drivers tend to badly abuse it
> (e.g. see some particular BSD derviced SCSI drivers). We definitely
> don't want any more of such code.

So you prefer random data corruption over an emergency stop?
That doesn't make much sense to me...
