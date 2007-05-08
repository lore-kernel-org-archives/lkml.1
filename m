Return-Path: <linux-kernel-owner+w=401wt.eu-S967229AbXEHM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967229AbXEHM72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966124AbXEHM7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:59:25 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:50080 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528AbXEHM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:59:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=IM33iNkaQwIvIl5824VauYw8PsTazOLRlAdrnMb6TdggFN8evhPfxjc1gAtES
	T6cjICSZzfPy9RZGm4sYcdo3w==
Date: Tue, 8 May 2007 14:59:21 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.3 - QMGR
Message-ID: <20070508125921.GA32669@xi.wantstofly.org>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3vef5biob.fsf@maximus.localdomain> <5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk> <m3hcqoa772.fsf@maximus.localdomain> <86D26EBE-5899-468F-9C79-23E83E0DE04B@cam.ac.uk> <m33b289zku.fsf@maximus.localdomain> <m31whs5ehn.fsf_-_@maximus.localdomain> <20070508113232.GA32055@xi.wantstofly.org> <f19298770705080547m3c0b5583qd6ad7aaca816361c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770705080547m3c0b5583qd6ad7aaca816361c@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:47:31PM +0400, Alexey Zaytsev wrote:

> > As with Christian's driver, I don't know whether an SRAM allocator
> > makes much sense.  We can just set up a static allocation map for the
> > in-tree drivers and leave out the allocator altogether.  I.e. I don't
> > think it's worth the complexity (and just because the butt-ugly Intel
> > code has an allocator isn't a very good reason. :-)
> 
> Is the qmgr used when the NPEs are utilized as DMA engines?

I'm not sure, but probably yes.


> And is the allocator needed in this case?

If you statically partition the available queue SRAM, no.
