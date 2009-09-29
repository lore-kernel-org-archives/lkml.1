Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZI2AXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZI2AXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZI2AXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:23:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:23736 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZI2AXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:23:52 -0400
Date: Mon, 28 Sep 2009 17:22:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tyhicks@linux.vnet.ibm.com
Subject: Re: [to-be-updated] ecryptfs-depends-on-crypto.patch removed from
 -mm tree
Message-Id: <20090928172254.bca66f54.randy.dunlap@oracle.com>
In-Reply-To: <200909290018.n8T0IU8X020007@imap1.linux-foundation.org>
References: <200909290018.n8T0IU8X020007@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AC15372.015C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 17:18:30 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      ecryptfs: depends on CRYPTO
> has been removed from the -mm tree.  Its filename was
>      ecryptfs-depends-on-crypto.patch
> 
> This patch was dropped because an updated version will be merged

what updated version?  hm, we'll see.


> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: ecryptfs: depends on CRYPTO
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ecryptfs uses crypto APIs so it should depend on CRYPTO.
> Otherwise many build errors occur. [63 lines not pasted]
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ecryptfs/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto fs/ecryptfs/Kconfig
> --- a/fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto
> +++ a/fs/ecryptfs/Kconfig
> @@ -1,6 +1,6 @@
>  config ECRYPT_FS
>  	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL && KEYS && NET
> +	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
>  	select CRYPTO_ECB
>  	select CRYPTO_CBC
>  	help


---
~Randy
