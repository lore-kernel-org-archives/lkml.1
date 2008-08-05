Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYHEKO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYHEKO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbYHEKOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:14:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:61385 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758557AbYHEKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:14:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,309,1215414000"; 
   d="scan'208";a="323235185"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20080804102711.1c6aecde.randy.dunlap@oracle.com>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <20080804102711.1c6aecde.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 06:12:59 -0400
Message-Id: <1217931179.1613.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 10:27 -0700, Randy Dunlap wrote:
> On Mon, 04 Aug 2008 05:35:07 -0400 Austin Zhang wrote:
> 
> > diff -Naurp linux-2.6/crypto/Kconfig linux-2.6-patch/crypto/Kconfig
> > --- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
> > +++ linux-2.6-patch/crypto/Kconfig	2008-08-04 01:59:00.000000000 -0400
> > @@ -221,6 +221,17 @@ config CRYPTO_CRC32C
> >  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
> >            Module will be crc32c.
> >  
> > +config CRYPTO_CRC32C_INTEL
> > +        tristate "CRC32c INTEL hardware acceleration"
> > +        select CRYPTO_HASH
> > +        help
> > +          In Intel processor with SSE4.2 supported, the processor will
> > +          support CRC32C implemetation using hardware accelerated CRC32 
> 
> 	                    implementation
> 
> > +          instruction. This option will create 'crc32c-intel' module,
> > +          which will enable any routine to use the CRC32 instruction to 
> > +          gain performance compared with software implementation.
> > +          Module will be crc32c-intel.
> 
> and don't end lines with spaces...
> 
> 
Thanks a lot:)

