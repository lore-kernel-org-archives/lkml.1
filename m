Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYFMSMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYFMSMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYFMSMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:12:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34968 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYFMSMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:12:19 -0400
Subject: Re: [RFC PATCH 2/2] Update defconfigs for CONFIG_HUGETLB
From: Adam Litke <agl@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, npiggin@suse.de, nacc@us.ibm.com,
       mel@csn.ul.ie, Eric B Munson <ebmunson@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-mips@linux-mips.org
In-Reply-To: <20080612193638.GB17231@cs181133002.pp.htv.fi>
References: <1213296540.17108.8.camel@localhost.localdomain>
	 <1213296945.17108.13.camel@localhost.localdomain>
	 <20080612193638.GB17231@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: IBM
Date: Fri, 13 Jun 2008 14:12:08 -0400
Message-Id: <1213380728.15016.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 22:36 +0300, Adrian Bunk wrote:
> On Thu, Jun 12, 2008 at 02:55:45PM -0400, Adam Litke wrote:
> > Update all defconfigs that specify a default configuration for hugetlbfs.
> > There is now only one option: CONFIG_HUGETLB.  Replace the old
> > CONFIG_HUGETLB_PAGE and CONFIG_HUGETLBFS options with the new one.  I found no
> > cases where CONFIG_HUGETLBFS and CONFIG_HUGETLB_PAGE had different values so
> > this patch is large but completely mechanical:
> >...
> >  335 files changed, 335 insertions(+), 385 deletions(-)
> >...
> 
> Please don't do this kind of patches - it doesn't bring any advantage 
> but can create tons of patch conflicts.
> 
> The next time a defconfig gets updated it will anyway automatically be 
> fixed, and for defconfigs that aren't updated it doesn't create any 
> problems to keep them as they are today until they might one day get 
> updated.

Thanks for taking a look.  I am not sure if I have ever seen a defconfig
patch hit the mailing list before and I was wondering how those changes
happen.  In any case I am perfectly happy to drop this huge patch and
stick with just the first one.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

