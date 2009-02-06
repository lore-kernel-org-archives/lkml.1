Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZBFDLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZBFDLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZBFDKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:10:42 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33941 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753305AbZBFDKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:10:41 -0500
Date: Fri, 6 Feb 2009 14:10:25 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
Message-ID: <20090206031025.GA3281@gondor.apana.org.au>
References: <b6a2187b0902050641h7943816ds26275a320e724440@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0902050641h7943816ds26275a320e724440@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:41:52PM +0800, Jeff Chua wrote:
> The following commit breaks "rlogin". Symptom is the terminal just
> hangs before login to the remote machine. No error, just the cursor
> never come back. "~." or type "exit" will exit from remote session.
> Only happens "sometimes". Happens more often if you try many times.
> 
> I've reverted the commit, and rlogin works now.

Could you please try a strace on both sides, with and without
this patch applied?

This breakage may well be unintentional since I can't see rlogin
producing more than 64K of data in urgent mode.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
