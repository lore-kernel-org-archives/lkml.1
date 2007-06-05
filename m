Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbXFENWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbXFENWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXFENWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:22:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:18318 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbXFENWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=katkC78yP1G81pAA2741ImLxLKnNAxB6xFyqzM49yOKf2GZHQKv+/WJLohQs0LQl4SSWqAq9UQUNOTyyhf0f5zrS7eEvplPDXH6u9Uqe9qa540yUW9VCq4+bRpBzgrH1xgMQRk3nD29csgjmGq5ZkkOPih19fhWLy0We3JAgOO0=
Message-ID: <46656395.30400@gmail.com>
Date: Tue, 05 Jun 2007 14:22:29 +0100
From: Michael-Luke Jones <mike.luke.jones@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@openedhand.com>
CC: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
Subject: Re: [PATCH -mm 1/5] Add LZO1X compression support to the kernel
References: <1180971384.6313.73.camel@localhost.localdomain>
In-Reply-To: <1180971384.6313.73.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> Index: linux-2.6.21/lib/Kconfig
> ===================================================================
> --- linux-2.6.21.orig/lib/Kconfig	2007-06-04 12:19:37.000000000 +0100
> +++ linux-2.6.21/lib/Kconfig	2007-06-04 12:19:46.000000000 +0100
> @@ -71,6 +71,11 @@ config AUDIT_GENERIC
>  	depends on AUDIT && !AUDIT_ARCH
>  	default y
>  
> +config LZO
> +	tristate "LZO compressor/decompressor"
> +	help
> +	  minilzo implementation in kernelspace.
> +
>  #
>  # compression support is select'ed if needed
>  #

Can this support option be hidden please, with decompression and
compression support Kconfig options separated out to support minimal
compilation of just the decompressor for read-only filesystems.

Michael-Luke
