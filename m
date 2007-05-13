Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXEMVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXEMVUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXEMVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:20:07 -0400
Received: from lixom.net ([66.141.50.11]:41832 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbXEMVUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:20:05 -0400
Date: Sun, 13 May 2007 16:22:57 -0500
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070513212257.GA24121@lixom.net>
References: <20070512143105.GA12890@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512143105.GA12890@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 09:31:05AM -0500, Olof Johansson wrote:
> ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
> are MMIO addresses, and remapped to a high range.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users.

Hold off on this one, with the current discussions going on it seems likely
that we'll be fine with 32 bits, just like arm/mips.

I'll repost within a day or two if needed.


-Olof
