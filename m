Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYGEUzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYGEUzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 16:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYGEUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 16:55:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYGEUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 16:55:36 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Olivier Galibert <galibert@pobox.com>,
       Takashi Iwai <tiwai@suse.de>, Hannes Reinecke <hare@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
In-Reply-To: <20080705171316.GA3615@infradead.org>
References: <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de>
	 <1215182557.10393.808.camel@pmac.infradead.org>
	 <20080704231322.GA4410@dspnet.fr.eu.org> <s5h4p746am3.wl%tiwai@suse.de>
	 <20080705105317.GA44773@dspnet.fr.eu.org> <486F596C.8050109@firstfloor.org>
	 <20080705120221.GC44773@dspnet.fr.eu.org> <486F6494.8020108@firstfloor.org>
	 <1215260166.10393.816.camel@pmac.infradead.org>
	 <20080705171316.GA3615@infradead.org>
Content-Type: text/plain
Date: Sat, 05 Jul 2008 21:55:11 +0100
Message-Id: <1215291312.3189.88.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 13:13 -0400, Christoph Hellwig wrote:
> On Sat, Jul 05, 2008 at 01:16:06PM +0100, David Woodhouse wrote:
> > It almost never happens that you have kernel versions which _need_
> > different firmware installed. In almost all cases, the older driver will
> > continue to work just fine with the newer firmware (and its bug-fixes).
> > 
> > The ABI between driver and firmware rarely changes in such a fashion
> > that you have to update the driver in lock-step -- and even on the
> > occasions that it does, it's not hard to simply change the name of the
> > "new-style" firmware so that it doesn't stomp on the old one (Think of
> > it like an soname).
> 
> That's unfortunately not true.  There are a lot of drivers that rely
> on specific firmware versions.

Do you have examples of such?

-- 
dwmw2

