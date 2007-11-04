Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXKDJSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXKDJSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 04:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXKDJS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 04:18:29 -0500
Received: from pxy2nd.nifty.com ([202.248.175.14]:63538 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754188AbXKDJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 04:18:26 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2007 04:18:26 EST
X-Nifty-SrcIP: [172.22.231.64]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=nifty.com;
  b=ncxJg1d9nZH7KY0NR6/KapnzMCivwbbxYJBXRYgKdBOzfsm/XQjqgJN9bTenksIj/z8Fkogqn8Shz4eJ5rCe1w==  ;
Message-ID: <24697997.78131194167504382.hqa02330@nifty.com>
Date: Sun, 4 Nov 2007 18:11:44 +0900 (JST)
From: Komuro <hqa02330@nifty.com>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2] pcmcia: Remove replace kio_addr_t with unsigned int everywhere
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071028201858.GA10048@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20071028201858.GA10048@lixom.net>
 <20070905142742.GA1760@lixom.net>
	<20070914034854.1658a9cf.akpm@linux-foundation.org>
	<20070921221516.GA7926@lixom.net>
	<20070921233936.2aeb2504@the-village.bc.nu>
	<20070922062551.GE10625@parisc-linux.org>
	<20070922091303.GA12525@lst.de> <20071019201720.GA13234@lixom.net>
	<20071028134414.GF26943@isilmar.linta.de>
	<20071028201034.GB9472@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

It should be "unsigned long" instead of "unsigned int".

64bit architecture uses 64bit-Memory-mapped-IO.



Best Regards
Komuro


>
>
>pcmcia: Remove replace kio_addr_t with unsigned int everywhere
>
>Remove kio_addr_t, and replace it with unsigned int. No known architecture
>needs more than 32 bits for IO addresses and ports and having a separate
>type for it is just messy.
>
>This goes on top of the patch switching the io_req_t members from ioaddr_t
>to unsigned int.
>
>
>Signed-off-by: Olof Johansson <olof@lixom.net>
>
>---
>
>On Sun, Oct 28, 2007 at 03:10:34PM -0500, Olof Johansson wrote:
>
>> This goes on top of the patch switching the io_req_t members from ioaddr_t
>> to unsigned int.
>
>Crap, I had an old version of that patch as base in my local tree when I did
>these edits. Here's a proper version.
>
>-Olof
>
