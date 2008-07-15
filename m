Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYGOFap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYGOFap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYGOFai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:30:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYGOFah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:30:37 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: benh@kernel.crashing.org
Cc: David Miller <davem@davemloft.net>, rene.herman@keyaccess.nl,
       david@lang.hm, torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216098939.7740.57.camel@pasglop>
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
	 <20080714.185207.203328391.davem@davemloft.net>
	 <487C0A12.9060906@keyaccess.nl>
	 <20080714.192425.241878700.davem@davemloft.net>
	 <1216098939.7740.57.camel@pasglop>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 22:30:08 -0700
Message-Id: <1216099808.27455.202.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:15 +1000, Benjamin Herrenschmidt wrote:
> > 
> > Thanks for proving something I tried to establish for weeks
> > but which Alan Cox, David W., and others vehemently denied.
> > 
> > They states that it was being done on a technical basis rather
> > than being predominantly a legal one.
> 
> Despite the risk of going against the current here, I do like David
> patches for one major reason: I love my kernels with everything
> built-in, that's how I can netboot them etc... without having to bother
> with installing modules.

I think you're definitely _with_ the current on that one.

> David's patches allow me to do that with drivers that would have
> -required- disk based firmwares beforehand. It allows things like
> rooting off a block device that needs a firmware without an initrd,
> etc....
> 
> As long as the firmwares are shipped with the kernel tree, I'm happpy,

They don't even need to be shipped with the kernel tree. You can set
CONFIG_EXTRA_FIRMWARE_DIR to point to wherever you keep them
(like /lib/firmware) and it'll pull them in from there. That's _why_
it's useful for drivers which would have required an initrd before, and
which don't have their firmware shipped in the kernel tree.

-- 
dwmw2

