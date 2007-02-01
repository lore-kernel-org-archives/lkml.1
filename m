Return-Path: <linux-kernel-owner+w=401wt.eu-S1422930AbXBASiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930AbXBASiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422931AbXBASiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:38:08 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3636 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422930AbXBASiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:38:07 -0500
Date: Thu, 1 Feb 2007 13:06:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Valdis.Kletnieks@vt.edu
Cc: Herbert Xu <herbert@gondor.apana.org.au>, wsl3@lrsehosting.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alan@redhat.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: Unidentified Intel wifi network card
Message-ID: <20070201180624.GC5408@tuxdriver.com>
References: <1170264624.5569.15.camel@scott-640m> <200701312054.l0VKstxg020891@turing-police.cc.vt.edu> <20070131215947.GA28294@gondor.apana.org.au> <200702011600.l11G08Zs015498@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011600.l11G08Zs015498@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 11:00:08AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 01 Feb 2007 08:59:47 +1100, Herbert Xu said:

> > If this driver is still using the old digest interface, it needs to be
> > converted to use crypto_hash_*.
> 
> OK, here's the more complete scoop - the *out of tree* ieee80211 tree
> hasn't been converted, but the *in tree* version has.
> 
> Why did I have the out of tree version installed? Because the in-tree
> version claimed to be 1.1.3, and the out-of-tree 1.2.16.  Apparently,
> the update to the version string for the in-kernel version got blocked
> someplace - the in-tree is apparently actually very close to 1.2.16.

I don't recall seeing such a patch, fwiw.  The only patch I recall
refusing from that team is the one that marks ipw2100 as broken
on big-endian.

If I missed those patches, please re-send them.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
