Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYHIRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYHIRxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbYHIRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:52:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:11759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYHIRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:52:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,334,1215414000"; 
   d="scan'208";a="427734853"
Date: Sat, 9 Aug 2008 10:52:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       austin zhang <austin_zhang@linux.intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809175247.GD13158@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809003829.GA25926@gondor.apana.org.au> <20080809142918.GA30387@gondor.apana.org.au> <20080809143259.GA30451@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809143259.GA30451@gondor.apana.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 07:32:59AM -0700, Herbert Xu wrote:
> On Sat, Aug 09, 2008 at 10:29:18PM +0800, Herbert Xu wrote:
> >
> > OK I take that back, Intel (and AMD) processors are equally affected
> > by this.  For a start, the newly added Intel crc32c driver suffers
> > from exactly the same problem since the instruction used is also
> > SSE.
> 
> Actually I was mistaken, Intel has done the right thing by not
> generating a fault on crc32c with TS set.

Yes, the documentation seems to says so. But I am double checking
with experts inside, to make sure we got the SDM right.
