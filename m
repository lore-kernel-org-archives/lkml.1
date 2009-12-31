Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZLaUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZLaUy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 15:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZLaUy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 15:54:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:40044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZLaUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 15:54:57 -0500
Subject: Re: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
From: David Woodhouse <dwmw2@infradead.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200EA54@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA54@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Dec 2009 20:54:41 +0000
Message-ID: <1262292881.3181.5632.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 16:30 -0500, H Hartley Sweeten wrote:
> 
> -       release_mem_region(res0->start, res0->end - res0->start + 1);
> +       release_mem_region(res0->start, resouce_size(res0)); 

That's not going to compile. I fixed it up.

Every patch in this batch failed to apply cleanly with git-am, too --
there was something odd about the whitespace at the end of each one.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

