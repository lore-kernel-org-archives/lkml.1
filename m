Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXKLNiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXKLNiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbXKLNhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:37:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344AbXKLNhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:37:54 -0500
Date: Mon, 12 Nov 2007 14:37:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Andreas Schwab <schwab@suse.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>, axboe@kernel.dk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Include header required for INT_MAX
In-Reply-To: <19f34abd0711120457x720f0ac8q9d6d0632e6a970fb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711121436490.24509@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr> 
 <jeabpj3fn1.fsf@sykes.suse.de>  <alpine.LFD.0.9999.0711120551380.23072@localhost.localdomain>
  <je1wav3bxh.fsf@sykes.suse.de> <19f34abd0711120457x720f0ac8q9d6d0632e6a970fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 12 2007 13:57, Vegard Nossum wrote:
>
>This seems like a good time to ask why the kernel doesn't use
><stdint.h> for its INT_MAX and type definitions like uint32_t., etc.
>>From the manpage: "The <stdint.h> header is a subset of the
><inttypes.h> header more suitable for use in freestanding
>environments, which might not support the formatted I/O functions. In
>some environments, if the formatted conversion support  is  not
>wanted,  using this header instead of the <inttypes.h> header avoids
>defining such a large number of macros."

Yes, I am all for that, replacing u8 __u8 with uint8_t, and so on.

