Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZKMMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZKMMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZKMMRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:17:08 -0500
Received: from d112a2.x-mailer.de ([212.162.53.4]:47977 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZKMMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:17:07 -0500
From: Karsten Keil <keil@b1-systems.de>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] mISDN: fix error return in HFCmulti_init()
Date: Fri, 13 Nov 2009 13:17:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.37-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4AFC3D85.6070904@gmail.com>
In-Reply-To: <4AFC3D85.6070904@gmail.com>
Organization: B1-systems
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911131317.10446.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 12. November 2009 17:53:25 Roel Kluin wrote:
 The returned error should stay negative
 
 Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Karsten Keil <keil@b1-systems.de>
 ---
  drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)
 
 diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c
  b/drivers/isdn/hardware/mISDN/hfcmulti.c index faed794..a6624ad 100644
 --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
 +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
 @@ -5481,7 +5481,7 @@ HFCmulti_init(void)
  		if (err) {
  			printk(KERN_ERR "error registering embedded driver: "
  				"%x\n", err);
 -			return -err;
 +			return err;
  		}
  		HFC_cnt++;
  		printk(KERN_INFO "%d devices registered\n", HFC_cnt);
 
