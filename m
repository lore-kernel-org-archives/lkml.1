Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXCaVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXCaVfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXCaVfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:35:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59187 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbXCaVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:35:50 -0400
Date: Sat, 31 Mar 2007 17:35:34 -0400
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Patrick McHardy <kaber@trash.net>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to advance through scatterlist
Message-ID: <20070331213534.GA18053@fieldses.org>
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com> <460DBC4C.1060602@trash.net> <20070331021437.GA31298@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331021437.GA31298@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 12:14:37PM +1000, Herbert Xu wrote:
> Indeed.  That patch was buggy.  Sorry for not catching this earlier.

Yep, thanks for the fix.  I used the wrong length, then tested with a
case where nbytes would always be less than PAGE_SIZE, which doesn't hit
this problem.  Apologies!

--b.
