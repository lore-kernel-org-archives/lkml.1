Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYHDR3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYHDR3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYHDR3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:29:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35584 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYHDR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:29:30 -0400
Date: Mon, 4 Aug 2008 10:27:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
 algorithm by new crypto API.
Message-Id: <20080804102711.1c6aecde.randy.dunlap@oracle.com>
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2008 05:35:07 -0400 Austin Zhang wrote:

> diff -Naurp linux-2.6/crypto/Kconfig linux-2.6-patch/crypto/Kconfig
> --- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
> +++ linux-2.6-patch/crypto/Kconfig	2008-08-04 01:59:00.000000000 -0400
> @@ -221,6 +221,17 @@ config CRYPTO_CRC32C
>  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
>            Module will be crc32c.
>  
> +config CRYPTO_CRC32C_INTEL
> +        tristate "CRC32c INTEL hardware acceleration"
> +        select CRYPTO_HASH
> +        help
> +          In Intel processor with SSE4.2 supported, the processor will
> +          support CRC32C implemetation using hardware accelerated CRC32 

	                    implementation

> +          instruction. This option will create 'crc32c-intel' module,
> +          which will enable any routine to use the CRC32 instruction to 
> +          gain performance compared with software implementation.
> +          Module will be crc32c-intel.

and don't end lines with spaces...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
