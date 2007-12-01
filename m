Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXLASZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXLASZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXLASZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:25:11 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39192 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXLASZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:25:10 -0500
Date: Sat, 1 Dec 2007 20:25:07 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>, jeff@garzik.org,
       akpm@osdl.org
Subject: Re: [PATCH] libata: Fix early use of port printk. (Was Re: ata4294967295:
 failed to start port (errno=-19))
In-Reply-To: <20071130152316.32e2effa@the-village.bc.nu>
Message-ID: <Pine.SOC.4.64.0712012024320.3541@math.ut.ee>
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
 <20071128200716.14eccfdd@the-village.bc.nu> <Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
 <20071130152316.32e2effa@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks. This should fix the real cause, and also allow for port start to
> fail politely with -ENODEV.

Works fine here - no more strange messages. Thank you!

-- 
Meelis Roos (mroos@linux.ee)
