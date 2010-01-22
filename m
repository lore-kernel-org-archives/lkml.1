Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491Ab0AVQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0AVQMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291Ab0AVQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:12:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51384 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab0AVQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=N9fGQ4cxh4rSQAWX6mDhTreSRO2i89Q6J6HFwvkmIR4i39UYVVnaFC+RpuOATJmYeQ
         C+NkHSUEZO///T0z/LtBgkggKKkSeSgjx1AM1654x+trjWdtuNE+HLMpHxZx6V/QkrOc
         RdlVvAzz0PRM292IWemxrhMDNQ6VfMAh3G0cM=
Subject: [PATCH 0/2] Smartmedia/xD support
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 18:12:45 +0200
Message-ID: <1264176765.24012.59.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is final patch series that depends on two former series and consist
of two patches.

First adds a driver for my xD card reader. Patch is almost unchanged
from previous submission.
I fixed few problems with suspend/resume. Device just works now.

Second patch, is a new SmartMedia/xD FTL support.
This version reverts many things I did in last version.
Driver again doesn't use mtd badblock handling.
Due to all kinds of problems I deciced it will be better to do it here.

I added support for 256 byte nand devices, thus now the FTL covers
everything. This is tested with nandsim.

I added lots of error checking. Driver is now very carefull and not
erase happy as it was. I decided that repairing the card should be done
by fsck like utility and not the driver.

Driver does some checks for device fails, by rereading the CIS.

Everything works now, and I think ready for use.

Best regards,
Maxim Levitsky


