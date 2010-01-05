Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266Ab0AESfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0AESfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110Ab0AESfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:35:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:38912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0AESfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:35:43 -0500
Subject: RE: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
From: David Woodhouse <dwmw2@infradead.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902089250@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA54@mi8nycmail19.Mi8.com>
	 <1262292881.3181.5632.camel@macbook.infradead.org>
	 <BD79186B4FD85F4B8E60E381CAEE190902089250@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 18:35:25 +0000
Message-ID: <1262716525.3181.7222.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 11:09 -0500, H Hartley Sweeten wrote:
> On Thursday, December 31, 2009 1:55 PM, David Woodhouse wrote:
> > On Mon, 2009-12-14 at 16:30 -0500, H Hartley Sweeten wrote:
> >> 
> >> -       release_mem_region(res0->start, res0->end - res0->start + 1);
> >> +       release_mem_region(res0->start, resouce_size(res0)); 
> >
> > That's not going to compile. I fixed it up.
> 
> Oops.. Sorry about that. Thanks for fixing.
> 
> > Every patch in this batch failed to apply cleanly with git-am, too --
> > there was something odd about the whitespace at the end of each one.
> 
> I had the same issue with some patches I sent to David Miller.  I think
> it's finally resolved.  My mailer was screwing with the last line in the
> message.  Sorry about that.
> 
> Do you need me to resubmit the series?

No, I have them. Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

