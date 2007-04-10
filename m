Return-Path: <linux-kernel-owner+w=401wt.eu-S1031071AbXDJQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031071AbXDJQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031093AbXDJQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:32:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031071AbXDJQcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:32:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="227828550:sNHT17739141"
Date: Tue, 10 Apr 2007 09:31:33 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com, keith.packard@intel.com
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization Technology for Directed I/O
Message-ID: <20070410163132.GC31505@linux-os.sc.intel.com>
References: <20070409215552.221374000@intel.com> <200704100949.56130.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704100949.56130.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:49:55AM +0200, Andi Kleen wrote:
> On Monday 09 April 2007 23:55:52 Ashok Raj wrote:
> 
> > Please help review and provide feedback.
> 
> High level question: how did you solve the "user X server needs IOMMU bypass"
> problem?

There is no special consideration for user space. Since all useful memeory is 
mapped 1-1, guess user space would work as is. Unless iam missing something 
here.. so yes.. there is no protection with 1-1, but guess its like 
compatibility mode until the code gets converted over.

Keith: cced says some of the user space side also is getting converted over with
some driver support possibly. So this is an interim problem until X catches up
with it.
> 
> -Andi
