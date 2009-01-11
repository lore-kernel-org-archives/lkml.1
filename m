Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZAKT1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZAKT1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZAKT1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:27:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:41458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAKT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:27:03 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <5a4c581d0901111124p753e0436q5dc3f4645e481c8b@mail.gmail.com>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	 <20090109.140422.60087297.davem@davemloft.net>
	 <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <1231678799.25018.195.camel@macbook.infradead.org>
	 <5a4c581d0901110842i5520cea1uff89d5772d0f3b6e@mail.gmail.com>
	 <1231692789.25018.415.camel@macbook.infradead.org>
	 <5a4c581d0901111124p753e0436q5dc3f4645e481c8b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 19:26:42 +0000
Message-Id: <1231702002.25018.482.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 20:24 +0100, Alessandro Suardi wrote:
> However, with the combination of in-kernel tg3 and
>  CONFIG_IN_KERNEL_FIRMWARE=n there is at least a 30" delay
>  during boot while waiting for the firmware request (which will fail).

Hm, ideally it should fail fast if the root file system isn't yet
mounted. I thought we'd seen and fixed a 'long delay' problem already.

I'll take another look.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

