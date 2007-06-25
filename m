Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbXFYFxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbXFYFxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXFYFxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:53:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33723 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXFYFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:53:12 -0400
Date: Mon, 25 Jun 2007 06:53:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@osdl.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [PATCH] pcmcia: ppc64 needs 32-bit ioaddr_t
Message-ID: <20070625055304.GA1057@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, akpm@osdl.org,
	linuxppc-dev@ozlabs.org, paulus@samba.org
References: <20070625005439.GA31289@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625005439.GA31289@lixom.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 07:54:39PM -0500, Olof Johansson wrote:
> ppc64 really needs ioaddr_t to be 32-bit, since I/O addresses really are
> MMIO addresses, and remapped at an offset that's well above 16 bits in
> some cases.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users.

Drivers should be using kio_addr_t, please fix up the remaining drivers
to do this instead of chaning the user-visible type.

