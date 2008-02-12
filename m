Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYBLEq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYBLEq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYBLEqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:46:18 -0500
Received: from pat.uio.no ([129.240.10.15]:34426 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYBLEqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:46:16 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	 <20080212042133.GA4625@kroah.com>
	 <20080211203146.3d28d1a0@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 23:45:55 -0500
Message-Id: <1202791555.20739.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: CAE4B6915A8A59F9148CEA36C12C9338B64E79D9
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 68 total 6821370 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 20:31 -0800, Arjan van de Ven wrote:
> in my experience, the only chance you have is doing API changes as first in the set of changes,
> and then hoping (making) all other trees use the new APIs. Any other order just turns into
> an impossible mismash.

It would be very nice to have a separate tree with _only_ API changes
that could be frozen well before Linus' merge window opens. It should be
a requirement that maintainers use this tree as a basis for testing API
changes and even test that their own changesets were properly integrated
with the changed APIs.
As it is, we tend to get the order entirely wrong: API changes typically
get merged _after_ the maintainer changes have been merged, and so no
API changes are ever really integration tested.

Cheers
  Trond

