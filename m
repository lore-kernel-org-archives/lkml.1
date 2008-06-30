Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYF3MvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYF3MvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYF3Mu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:50:57 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:58165 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYF3Mu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:50:56 -0400
Message-Id: <200806301250.m5UCofNg022031@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM driver to request_firmware()
In-reply-to: <1214818473.10393.337.camel@pmac.infradead.org>
Date: Mon, 30 Jun 2008 08:50:41 -0400
X-NRLCMF-Spam-Score: () hits=-0.021
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1214818473.10393.337.camel@pmac.infradead.org>,David Woodhouse writ
es:
>Sorry for dropping this; I'll let it go through the net tree now it's
>there.

ok

>A couple of comments though... it looks like you forgot to add
>MODULE_FIRMWARE(). And shouldn't 'fw_data' in

yes.  i will get davem a patch for that asap.

>fore200e_load_and_start_firmware() be a (__le32 *) not a (u32 *)?

yes, it certainly could be.
