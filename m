Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXIUWw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXIUWw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXIUWdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:33:05 -0400
Received: from [81.2.110.250] ([81.2.110.250]:48997 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763125AbXIUWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:33:03 -0400
Date: Fri, 21 Sep 2007 23:39:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, hch@lst.de, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070921233936.2aeb2504@the-village.bc.nu>
In-Reply-To: <20070921221516.GA7926@lixom.net>
References: <20070905142742.GA1760@lixom.net>
	<20070914034854.1658a9cf.akpm@linux-foundation.org>
	<20070921221516.GA7926@lixom.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 17:15:16 -0500
Olof Johansson <olof@lixom.net> wrote:

> Convert the io_req_t members to kio_addr_t, to allow use on machines with
> more than 16 bits worth of IO ports (i.e. secondary busses on ppc64, etc).

What about the formatting and field widths ?

ulong would probably be a lot saner than kio_addr_t and yet more type
obfuscation.

Otherwise looks sensible to me
