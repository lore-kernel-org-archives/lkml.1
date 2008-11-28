Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYK1Bag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYK1Bag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 20:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYK1Ba2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 20:30:28 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:49754 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYK1Ba1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 20:30:27 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH-mm 8/8] decnet: remove private wrappers of endian helpers
Date: Fri, 28 Nov 2008 02:32:21 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       "linux-netdev" <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1227733974.5511.130.camel@brick>
In-Reply-To: <1227733974.5511.130.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811280232.21544.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

On Wednesday 26 November 2008, Harvey Harrison wrote:
> diff --git a/include/net/dn.h b/include/net/dn.h
> index 6277783..7cd6bb8 100644
> --- a/include/net/dn.h
> +++ b/include/net/dn.h
> @@ -4,9 +4,7 @@
>  #include <linux/dn.h>
>  #include <net/sock.h>
>  #include <asm/byteorder.h>
> -
> -#define dn_ntohs(x) le16_to_cpu(x)
> -#define dn_htons(x) cpu_to_le16(x)
> +#include <asm/unalignedh>
^^^^^^^^^^^^^^^^^^^^^^^^^^^ How does this compile?

But I guess David fixed this up :-)

Best Regards

Ingo Oeser

