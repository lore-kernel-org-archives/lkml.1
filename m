Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZAKWmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZAKWmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZAKWmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:42:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:52401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZAKWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:42:05 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090111.140559.126980927.davem@davemloft.net>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	 <20090111.133929.57600645.davem@davemloft.net>
	 <1231711347.25018.658.camel@macbook.infradead.org>
	 <20090111.140559.126980927.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 22:41:38 +0000
Message-Id: <1231713698.25018.700.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 14:05 -0800, David Miller wrote:
> So what used to work out of the box by typing make now
> will have all kinds of strange depencies, right?
> 
> This is a regression, no matter how you spin it, in my
> book.

I know you think that, but I disagree. Yes, it's slightly less
convenient for a small handful of older drivers, but in the general case
it's a massive improvement -- because now we can have a single canonical
location to collect _all_ the firmware that is redistributable, for use
with the kernel. And we've already started adding a whole bunch of new
firmwares to that repository.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

