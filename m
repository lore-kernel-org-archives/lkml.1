Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXCYPoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXCYPoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXCYPoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:44:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4358 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473AbXCYPob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:44:31 -0400
Date: Sun, 25 Mar 2007 12:13:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
Message-ID: <20070325121321.GA8550@ucw.cz>
References: <1174666176.11149.3.camel@localhost.localdomain> <20070325001605.31ed39e7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325001605.31ed39e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +++ linux-2.6.21-rc4-mm1/security/evm/Kconfig
> > @@ -0,0 +1,17 @@
> > +config INTEGRITY_EVM
> > +	boolean "EVM support"
> > +	depends on INTEGRITY && KEYS
> > +	select CRYPTO_HMAC
> > +	select CRYPTO_MD5
> > +	select CRYPTO_SHA1
> > +	default 0
> > +	help
> > +	  The Extended Verification Module is an integrity provider.
> > +	  An extensible set of extended attributes, as defined in
> > +	  /etc/evm.conf, are HMAC protected against modification
> > +	  using the TPM's KERNEL ROOT KEY, if configured, or with a
> > +	  pass-phrase.  Possible extended attributes include authenticity,
> > +	  integrity, and revision level.

What is identity provider good for? Can you explain it a bit more, or
perhaps point to Doc*/ somewhere?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
