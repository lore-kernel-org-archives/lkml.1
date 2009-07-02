Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZGBVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZGBVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZGBVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:30:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57999 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZGBVa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:30:27 -0400
Date: Thu, 2 Jul 2009 23:30:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v6][PATCH 4/4] intel_txt: force IOMMU on for Intel(R) TXT
	launch
Message-ID: <20090702213013.GC1419@ucw.cz>
References: <4A4ACA6E.6080702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4ACA6E.6080702@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue 2009-06-30 19:31:10, Joseph Cihula wrote:
> The tboot module will DMA protect all of memory in order to ensure the that
> kernel will be able to initialize without compromise (from DMA).  Consequently,
> the kernel must enable Intel(R) Virtualization Technology for Directed I/O
> (VT-d or Intel IOMMU) in order to replace this broad protection with the
> appropriate page-granular protection.  Otherwise DMA devices will be unable
> to read or write from memory and the kernel will eventually panic.
> 
> Because runtime IOMMU support is configurable by command line options, this
> patch will force it to be enabled regardless of the options specified, and will
> log a message if it was required to force it on.
> 
> 
>  dmar.c        |    7 +++++++
>  intel-iommu.c |   17 +++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
> Signed-off-by: Shane Wang <shane.wang@intel.com>

NAK. Breaks user expectations, misses  docs updates. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
