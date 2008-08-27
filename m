Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYH0JCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYH0JCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYH0JCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:02:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYH0JCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:02:15 -0400
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tim Anderson <tanderson@mvista.com>, dedekind@infradead.org,
       Bruce_Leonard@selinc.com, "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-mtd-bounces@lists.infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, "'Bruce Leonard'" <brucle@earthlink.net>
In-Reply-To: <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
References: <1219817017.18027.149.camel@sauron>
	 <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
	 <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 10:01:32 +0100
Message-Id: <1219827692.7107.170.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 09:39 +0100, Alan Cox wrote:
> On Tue, 26 Aug 2008 23:20:46 -0700
> "Tim Anderson" <tanderson@mvista.com> wrote:
> 
> > Artem,
> > 
> > I see your point. Ioctls are going away after all.
> 
> I don't know where that stupid story keeps coming from. Ioctl is alive
> and well and there are more not less of them. There are lots of things
> you *cannot* do with sysfs, including synchronization and handling
> many kinds of changes to objects that can appear and disappear. Ditto
> there are problems with getting a consistent snapshot via sysfs because
> you can't atomically read multiple fields.
> 
> So please stop this 'ioctls are going away' stuff, its bunkum.

True, and we'll definitely need a new MEMERASE64 ioctl. But for the
_informational_ parts, those can happily be done through sysfs.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



