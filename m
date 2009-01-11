Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZAKQ75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZAKQ75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZAKQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:59:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:57448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZAKQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:59:45 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: David Miller <davem@davemloft.net>, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <58054.1231692502@turing-police.cc.vt.edu>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	 <20090109.140422.60087297.davem@davemloft.net>
	 <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <1231678799.25018.195.camel@macbook.infradead.org>
	 <58054.1231692502@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 16:56:02 +0000
Message-Id: <1231692963.25018.422.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 11:48 -0500, Valdis.Kletnieks@vt.edu wrote:
> One unanswered question:  What do we expect the system to do if they have this
> patch, TIGON3=y, FIRMWARE_IN_KERNEL=n, and configure a netconsole for boot
> messages?  I'm *hoping* the answer is "the netconsole doesn't come up at boot,
> but can be re-enabled via the /sys/kernel/config/netconsole interface after
> you've done an 'ifconfig eth0 up' or similar, or do a 'modprobe netconsole'.
> 
> Those seem like reasonable semantics to me - anybody got a different opinion?

If netconsole follows the normal ->open() path, that sounds like what'll
happen.

-- 
dwmw2

