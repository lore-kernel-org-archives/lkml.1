Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbYCLHg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbYCLHg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYCLHgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:36:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYCLHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:36:49 -0400
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20080311225926.6515e18c.akpm@linux-foundation.org>
References: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
	 <20080311225926.6515e18c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 08:36:51 +0100
Message-Id: <1205307411.2592.120.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 22:59 -0700, Andrew Morton wrote:
> > This solution would require simply changing the parser configuration
> > options to bool in drivers/mtd/Kconfig. Is there a reason to allow the
> > parsing code to be built as a module?
> 
> That sounds reasonable.

I have no particular objection to that. But shouldn't we call
af_unix_init() earlier if modprobe doesn't run without it? 

> I'd suggest that you make your own decision as to what is the best fix, then
> send a patch.  Please cc me on it and I'll make sure that it gets
> appropriately handled.  This may take a bit of time, as the MTD patch
> backlog is rather large at present.

Yeah, things have been interesting. But I get to spend a whole three
weeks at home, starting next week. So feel free to LART me if I don't
catch up. Thanks, again, for your help in making sure things don't fall
through the cracks.

-- 
dwmw2

