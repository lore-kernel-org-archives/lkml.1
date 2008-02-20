Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYBTDpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYBTDpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYBTDp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:45:29 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:39694 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281AbYBTDp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:45:28 -0500
Date: Wed, 20 Feb 2008 11:45:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
Message-ID: <20080220034515.GC22703@gondor.apana.org.au>
References: <47BA0984.2070306@cybernetics.com> <1203381120.13495.78.camel@dell> <20080218.163554.74130592.davem@davemloft.net> <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com> <1203448265.13495.95.camel@dell> <47BB54C2.6090501@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BB54C2.6090501@cybernetics.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:14:26PM -0500, Tony Battersby wrote:
>
> Update: when I revert Herbert's patch in addition to applying your
> patch, the iSCSI performance goes back up to 115 MB/s again in both
> directions.  So it looks like turning off SG for TX didn't itself cause
> the performance drop, but rather that the performance drop is just
> another manifestation of whatever bug is causing the data corruption.

Interesting.  So the workload that regressed is mostly RX with a
little TX traffic? Can you try to reproduce this with something
like netperf to eliminate other variables?

This is all very puzzling since the patch in question shouldn't
change an RX load at all.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
