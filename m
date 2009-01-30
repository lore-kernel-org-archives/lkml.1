Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbZA3AIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbZA3AIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbZA3AIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:08:19 -0500
Received: from tundra.namei.org ([65.99.196.166]:1374 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921AbZA3AIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:08:18 -0500
Date: Fri, 30 Jan 2009 11:07:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: IMA as an integrity service provider
In-Reply-To: <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0901301032080.29870@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Mimi Zohar wrote:

> +++ b/security/integrity/ima/Kconfig
> @@ -0,0 +1,49 @@
> +# IBM Integrity Measurement Architecture
> +#
> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on ACPI
> +	select SECURITYFS
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select TCG_TPM
> +	select TCG_TIS
> +	help
> +	  The Trusted Computing Group(TCG) runtime Integrity
> +	  Measurement Architecture(IMA) maintains a list of hash
> +	  values of executables and other sensitive system files,
> +	  as they are read or executed. If an attacker manages
> +	  to change the contents of an important system file
> +	  being measured, we can tell.

Out of interest, do you know if the TCG has analyzed their use of SHA-1 
in light of various attacks on the algorithm over the last few years?

The IETF has published analysis and recommendations relating to the use of 
SHA-1 (and other cryptographic hashes) with IP protocols:

http://www.ietf.org/rfc/rfc4894.txt
http://www.ietf.org/rfc/rfc4270.txt

It would be useful to know if similar analysis has been performed for TPM.


- James
-- 
James Morris
<jmorris@namei.org>
