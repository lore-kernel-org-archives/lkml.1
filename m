Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZD1DPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZD1DPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZD1DPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:15:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:10793 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZD1DPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,258,1239001200"; 
   d="scan'208";a="136606456"
Date: Tue, 28 Apr 2009 11:15:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Vivek Kashyap <vivk@us.ibm.com>, Mel Gorman <mel@linux.vnet.ibm.com>,
       Robert MacFarlan <Robert_MacFarlan@us.ibm.com>,
       "Fu, Michael" <michael.fu@intel.com>
Subject: Re: Large Pages - Linux Foundation HPC
Message-ID: <20090428031520.GA17434@localhost>
References: <1240331533.32731.2.camel@badari-desktop> <1240333025.32604.392.camel@nimitz> <20090421182555.GA8977@balbir.in.ibm.com> <20090425084804.GA517@localhost> <1240728861.29485.41.camel@nimitz> <alpine.DEB.1.10.0904271010300.1474@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904271010300.1474@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:12:26PM +0800, Christoph Lameter wrote:
> On Sat, 25 Apr 2009, Dave Hansen wrote:
> 
> > On Sat, 2009-04-25 at 16:48 +0800, Wu Fengguang wrote:
> > > Based on Dave's descriptions that HPC apps typically
> > > - do mlock(), to pre-populate memory and pin them in memory
> > > - run at fresh boot, with loads of high order pages available
> >
> > There are definitely some of them that do this, but it certainly isn't
> > all.  It may not even be the norm.
> 
> Some of the machine have so much memory available that 2M allocations are
> likely to succeed. If a machine has a couple of terabytes of memory
> available then its highly unlikely that a 2M allocation will not succeed.

Huge pages used to be explicitly managed as scarce resources. As time
goes by I'd imagine the move to "huge page as an optimization" POV.
Optimizations that can benefit unmodified applications and can fail
gracefully.
