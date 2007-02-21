Return-Path: <linux-kernel-owner+w=401wt.eu-S1422667AbXBUQja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbXBUQja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXBUQja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:39:30 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:29923 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667AbXBUQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:39:29 -0500
Date: Wed, 21 Feb 2007 08:34:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Sterba <dave@jikos.cz>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Fix trivial help text typos in Kconfig* files
Message-Id: <20070221083418.c0dfdbc1.randy.dunlap@oracle.com>
In-Reply-To: <20070221081628.GB27718@twin.jikos.cz>
References: <20070221081628.GB27718@twin.jikos.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 09:16:28 +0100 David Sterba wrote:

> (patch against 2.6.21-rc1)
> 
> Fix several typos in help text in Kconfig* files.
> 
> Signed-off-by: David Sterba <dave@jikos.cz>

Looks good except for one item below.  Thanks.

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 086fcec..9f954fd 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -258,7 +258,7 @@ config CRYPTO_SERPENT
>  
>  	  Keys are allowed to be from 0 to 256 bits in length, in steps
>  	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
> -	  variant of Serpent for compatibility with old kerneli code.
> +	  variant of Serpent for compatibility with old kernel code.

This refers to the former kerneli.org crypto code.
Maybe it should say "old kerneli.org code."

>  	  See also:
>  	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
