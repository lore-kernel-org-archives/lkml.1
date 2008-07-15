Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbYGOWno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbYGOWno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYGOWnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:43:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbYGOWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:43:34 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, torvalds@linux-foundation.org, tytso@mit.edu,
       david@lang.hm, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080715.144720.66126410.davem@davemloft.net>
References: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
	 <487D1327.7090805@garzik.org>
	 <1216157061.26991.41.camel@shinybook.infradead.org>
	 <20080715.144720.66126410.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:42:32 -0700
Message-Id: <1216161752.26991.61.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 14:47 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Tue, 15 Jul 2008 14:24:21 -0700
> 
> > Kernel 2.6.15 with ancient userland. You update to 2.6.16, which
> > includes commit 5433383e ('convert qla2xxx to request_firmware()').
> > 
> > Same problem?
> 
> For the record I did get burnt by that one and I did make a huge stink
> about it.
> 
> I used to be able to avoid initrd entirely on every single one of my
> boxes, even my machines with qla2xxx based root filesystems, and that
> changeset basically meant the end of that.

Until now. The only significant _generic_ change that just went into
Linus' kernel is the fact that you can now build that firmware _into_
your kernel, and you can boot qla2xxx without an initrd again.

HTH.

-- 
dwmw2

