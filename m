Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYHJFb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYHJFb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 01:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYHJFbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 01:31:18 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48373 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbYHJFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 01:31:17 -0400
Date: Sun, 10 Aug 2008 13:30:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       austin zhang <austin_zhang@linux.intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080810053048.GA3171@gondor.apana.org.au>
References: <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809003829.GA25926@gondor.apana.org.au> <20080809142918.GA30387@gondor.apana.org.au> <20080809143259.GA30451@gondor.apana.org.au> <20080809175247.GD13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809175247.GD13158@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 10:52:48AM -0700, Suresh Siddha wrote:
>
> > Actually I was mistaken, Intel has done the right thing by not
> > generating a fault on crc32c with TS set.
> 
> Yes, the documentation seems to says so. But I am double checking
> with experts inside, to make sure we got the SDM right.

Thanks for checking this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
