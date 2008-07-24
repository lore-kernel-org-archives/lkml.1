Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYGXPL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYGXPL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYGXPLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:11:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYGXPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:11:49 -0400
Date: Thu, 24 Jul 2008 08:05:43 -0700
From: Greg KH <greg@kroah.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Chuck Wolber <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Jake Edge <jake@lwn.net>, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
Message-ID: <20080724150543.GA10549@kroah.com>
References: <20080722230208.148102983@mini.kroah.org> <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de> <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com> <20080723201258.GA26156@kroah.com> <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org> <20080723203250.GA26454@kroah.com> <74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:33:34PM +0200, pHilipp Zabel wrote:
> Both should be applied together. Although it is unlikely that with the
> broken patch MMC accesses will accidentally clear the DALGN bits of
> other running (unaligned) DMA chains (I'm not aware of any drivers
> using unaligned DMA), the PXA27x developer manual says that this "must
> not" be done. If it would result in memory corruption or lockups, I
> don't know.

Ok, I'll add them both to the .26 queue as well.

thanks for the information,

greg k-h
