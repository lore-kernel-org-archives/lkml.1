Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZGUVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZGUVdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZGUVdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:33:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZGUVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:33:36 -0400
Date: Tue, 21 Jul 2009 17:33:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: Do cpu-endian MMIO accessors exist?
Message-ID: <20090721213333.GA27202@infradead.org>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <4A662C33.7080505@gmail.com> <200907212315.50225.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907212315.50225.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 11:15:49PM +0200, Arnd Bergmann wrote:
> The best solution would be if you could find a way to set
> the hardware into little-endian mode on all architectures.
> >From the description, it sounds like the hardware should allow that.

Why would you want to do that?  That just means a useless byteswap.
We really should have a generic native-endian MMIO-access API as there
is quite a bit of hardware with features like that, and currently we
have a miriad of hacks using __raw_* and manual barriers, the ppc
specific accessors and god knows what.

