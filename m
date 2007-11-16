Return-Path: <linux-kernel-owner+w=401wt.eu-S1764387AbXKPUps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764387AbXKPUps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXKPUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:45:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36821 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbXKPUpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:45:41 -0500
Subject: Re: [PATCH] Driver core: fix race in __device_release_driver
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071116203748.GA11770@kroah.com>
References: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
	 <20071116203748.GA11770@kroah.com>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 15:45:55 -0500
Message-Id: <1195245955.2533.153.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 12:37 -0800, Greg KH wrote:
> Is this something that you all feel is worth getting in for 2.6.24?
> Does it fix a regression that just showed up, or is just a bugfix for
> something that people finally realized has always been there?

The latter. We just happen to kick the wireless device in the head by
toggling its out-of-band reset signal when we unload the driver, which
causes us to trigger this "unlikely" race with almost 100% reliability.
But it's always been there, AFAICT.

> Can it wait for 2.6.25 to get some more testing in -mm?

Yeah, I think so.

-- 
dwmw2

