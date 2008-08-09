Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYHIOdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYHIOdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYHIOdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:33:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54362 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751421AbYHIOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:33:10 -0400
Date: Sat, 9 Aug 2008 22:32:59 +0800
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
Message-ID: <20080809143259.GA30451@gondor.apana.org.au>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809003829.GA25926@gondor.apana.org.au> <20080809142918.GA30387@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809142918.GA30387@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 10:29:18PM +0800, Herbert Xu wrote:
>
> OK I take that back, Intel (and AMD) processors are equally affected
> by this.  For a start, the newly added Intel crc32c driver suffers
> from exactly the same problem since the instruction used is also
> SSE.

Actually I was mistaken, Intel has done the right thing by not
generating a fault on crc32c with TS set.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
