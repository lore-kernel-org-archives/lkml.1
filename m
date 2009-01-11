Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZAKQxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZAKQxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZAKQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:53:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:48168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZAKQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:53:33 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <5a4c581d0901110842i5520cea1uff89d5772d0f3b6e@mail.gmail.com>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	 <20090109.140422.60087297.davem@davemloft.net>
	 <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <1231678799.25018.195.camel@macbook.infradead.org>
	 <5a4c581d0901110842i5520cea1uff89d5772d0f3b6e@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 16:53:09 +0000
Message-Id: <1231692789.25018.415.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 17:42 +0100, Alessandro Suardi wrote:
> Patches cleanly but doesn't build in 2.6.29-rc1:

Pants; sorry, I omitted this bit...

diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index ae5da60..508def3 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2764,6 +2764,7 @@ struct tg3 {
 	struct ethtool_coalesce		coal;
 
 	/* firmware info */
+	const char			*fw_needed;
 	const struct firmware		*fw;
 	u32				fw_len; /* includes BSS */
 };

-- 
dwmw2

