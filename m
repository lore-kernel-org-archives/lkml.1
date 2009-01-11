Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZAKWDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZAKWDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZAKWDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:03:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:46774 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:03:17 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090111.133929.57600645.davem@davemloft.net>
References: <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <20090111.133929.57600645.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 22:02:27 +0000
Message-Id: <1231711347.25018.658.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 13:39 -0800, David Miller wrote:
> For example, for mounting an NFS root using that device.... Oh, will I
> need an initramfs for that once you pull the firmware-in-kernel
> option?

The option to build arbitrary firmware into your kernel is never going
to be pulled. You can do nfsroot on your myri10ge today, without initrd,
even though the firmware is distributed separately from the kernel. That
doesn't prevent you from building it _in_ to your kernel, if you choose
to.

-- 
dwmw2

