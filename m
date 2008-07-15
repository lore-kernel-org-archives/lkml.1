Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYGOCYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYGOCYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGOCYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:24:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYGOCYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:24:08 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080714.191727.223788995.davem@davemloft.net>
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	 <1216082213.27455.109.camel@shinybook.infradead.org>
	 <487C0788.7030907@garzik.org>
	 <20080714.191727.223788995.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 19:23:55 -0700
Message-Id: <1216088636.27455.163.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 19:17 -0700, David Miller wrote:
> When module support was added, guess what?  I could still build a
> completely static kernel image like I always could.
> 
> And in fact, to this day, that's what I personally do because that's
> how I like my kernels.

Good. You can still do precisely that, and build the firmware into your
kernel. You can have exactly what you like. Hey, you can build even
_more_ firmware into your kernel now. You can have NFS-root on devices
you previously had to use an initrd for. hth.

> But this request_firmware() change does not allow one to get what he
> could get before, which is a completely self-contained driver module
> object file.
> 
> This is the difference between providing an option and making
> something mandatory.  This firmware split up is now mandatory.

In all the years we've been using request_firmware(), nobody ever asked
for a way to build the firmware _into_ the .ko file, until now. Why is
it suddenly so important for a small handful of older network drivers,
when nobody else has ever seen the need for it -- even in modern network
drivers?

-- 
dwmw2

