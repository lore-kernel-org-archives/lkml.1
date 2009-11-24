Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbZKXJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbZKXJmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbZKXJmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:42:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:59277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbZKXJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:42:00 -0500
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in
 2.6.27
From: David Woodhouse <dwmw2@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Monty Montgomery <xiphmont@gmail.com>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Der Mickster <retroeffective@gmail.com>
In-Reply-To: <4B0BA71B.8040800@ladisch.de>
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
	 <4B0BA71B.8040800@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:42:01 +0000
Message-ID: <1259055721.29729.277.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 10:27 +0100, Clemens Ladisch wrote:
> 
> > Bug 3: Fixing the first two problems prevents the oops and allows
> the
> > USB stack to successfully allocate an endpoint without crashing the
> > eMagic.  However, the eMagic crashes and lights its red INTERNAL
> ERROR
> > led later as it tries to start up.  This problem can be traced to
> the
> > linux/firmware/emi62/bistream.HEX file, which is loading different
> > FPGA firmware as compared to the driver pre-2.6.27.
> > [...]
> > Due to the size of the patch (the replacement firmware file is
> 250kB),
> > I've not attached it but rather stashed it at:
> > 
> > http://web.mit.edu/xiphmont/Public/emi/emi62.patch
> 
> I don't have much time; David, please handle this. 

Where did the new firmware come from?

I think the best option at this point is to remove it from the firmware/
directory and add the new one to the linux-firmware.git repository.

-- 
dwmw2

