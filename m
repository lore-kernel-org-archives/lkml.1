Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYHDK2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYHDK2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYHDK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:28:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYHDK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:28:11 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Austin Zhang <austin_zhang@linux.intel.com>, herbert@gondor.apana.org.au,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:27:57 +0100
Message-Id: <1217845677.3454.582.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 12:25 +0200, Sebastian Siewior wrote:
> * David Woodhouse | 2008-08-04 11:12:05 [+0100]:
> >And it would be nice if we could make libcrc32c use this too, rather
> >than just the 'crypto' users.
> 
> I'm not sure if I remeber correctly but I thing Herbert was planning to
> convert all users over to the crypto API to avoid compile time
> dependency.

That's one way of doing it, although it seems a little bit like overkill
in this particular case.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



