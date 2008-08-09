Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYHIRsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYHIRsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYHIRsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:48:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:57978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYHIRsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:48:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,334,1215414000"; 
   d="scan'208";a="427734347"
Date: Sat, 9 Aug 2008 10:48:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809174821.GC13158@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809003829.GA25926@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809003829.GA25926@gondor.apana.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 05:38:30PM -0700, Herbert Xu wrote:
> On Fri, Aug 08, 2008 at 04:11:21PM -0700, Suresh Siddha wrote:
> >
> > As I can't test, can you please test this and Ack.
> 
> Someone please test this with tcrypt mode=200 with and without
> the patch.

Yes. I mean both perf and stability tests when I meant by "test".

> If there is a significant degradation I suggest that we back out
> the FPU changes.  Making your competitor's processor go slow is
> not a nice thing to do, especially when you've just released a
> processor in the same space.

Please be assured that I would like to close/adddress all the perf and
stability issues and it doesn't matter whose processor it is ;)
