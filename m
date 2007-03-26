Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXCZF2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXCZF2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbXCZF2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:28:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbXCZF2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:28:06 -0400
Date: Sun, 25 Mar 2007 21:28:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
Message-Id: <20070325212802.194a4b00.akpm@linux-foundation.org>
In-Reply-To: <1174878782.6487.0.camel@localhost.localdomain>
References: <1174666176.11149.3.camel@localhost.localdomain>
	<20070325001605.31ed39e7.akpm@linux-foundation.org>
	<1174878782.6487.0.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 23:13:02 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Sun, 2007-03-25 at 00:16 -0800, Andrew Morton wrote:
> > On Fri, 23 Mar 2007 12:09:36 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > 
> > > +++ linux-2.6.21-rc4-mm1/security/evm/Kconfig
> > > @@ -0,0 +1,17 @@
> > > +config INTEGRITY_EVM
> > > +	boolean "EVM support"
> > > +	depends on INTEGRITY && KEYS
> > > +	select CRYPTO_HMAC
> > > +	select CRYPTO_MD5
> > > +	select CRYPTO_SHA1
> > > +	default 0
> > > +	help
> > > +	  The Extended Verification Module is an integrity provider.
> > > +	  An extensible set of extended attributes, as defined in
> > > +	  /etc/evm.conf, are HMAC protected against modification
> > > +	  using the TPM's KERNEL ROOT KEY, if configured, or with a
> > > +	  pass-phrase.  Possible extended attributes include authenticity,
> > > +	  integrity, and revision level.
> > > +
> > > +	  If you are unsure how to answer this question, answer N.
> > > +
> > 
> > Is no dependency upon TPM needed?
> 
> It's obviously preferable to have and use a TPM, but if one is not
> available you can use a pass-phrase.
> 

So it will compile and run OK with CONFIG_TPM=n?  And with
CONFIG_INTEGRITY_EVM=y, CONFIG_TPM=m?

