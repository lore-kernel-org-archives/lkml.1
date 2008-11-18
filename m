Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYKROPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYKROPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYKROPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:15:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33967 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYKROPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:15:31 -0500
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
	parse_mtd_partitions
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1227017078.16925.123.camel@sauron>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
	 <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
	 <8bd0f97a0811120808p5858d5adleeef43b1d374bee1@mail.gmail.com>
	 <1227016647.27728.398.camel@macbook.infradead.org>
	 <1227017078.16925.123.camel@sauron>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 14:15:26 +0000
Message-Id: <1227017726.27728.402.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 16:04 +0200, Artem Bityutskiy wrote:
> Off topic: is this going to really happen? Are you have real plans
> to do this?

The plans for partitioning aren't entirely defined, but yes -- we have
to do it.

> Also, you also mentioned that you have sysfs for MTD, are we going to
> see them in mtd-2.6.git any time soon?

I did a bunch of it when I was on the plane to the kernel summit and
plumbers conference. I should get it to actually compile and then put it
in a separate tree -- I don't think it'll be ready for merging to Linus
imminently.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

