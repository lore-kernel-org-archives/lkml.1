Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbXFZQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbXFZQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXFZQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:38:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:60781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXFZQi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:38:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="243570175"
Date: Tue, 26 Jun 2007 09:33:56 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-ID: <20070626163356.GE3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.716432000@askeshav-devel.jf.intel.com> <20070625232511.3fc07f8f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625232511.3fc07f8f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:25:11PM -0700, Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:37:06 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> 
> None of these actually _need_ to be macros and it would be better to 
> implement them in C.  That way things are more self-documenting, more
> pleasant to read, more likely to get commented and you'll fix the
> two bugs wherein the argument to a macro is evaluated more than once.
Agree. Will send a patch when I get back from OLS as any changes to this
needs thorugh testing.

-Anil
