Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYF3Jev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYF3Jev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbYF3Jeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:34:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYF3Jeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:34:36 -0400
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
	driver to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200806051606.m55G6OTP029329@cmf.nrl.navy.mil>
References: <200806051606.m55G6OTP029329@cmf.nrl.navy.mil>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 10:34:33 +0100
Message-Id: <1214818473.10393.337.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 12:06 -0400, Chas Williams (CONTRACTOR) wrote:
> yes, it is troubling.  along the same lines, this patch removes the
> pca200e/sba200e firmware from the kernel.  the firmware will be in the
> next release of the userspace atm tools.  i could move the ambassador
> firmware there as well if you would like.

Sorry for dropping this; I'll let it go through the net tree now it's
there.

A couple of comments though... it looks like you forgot to add
MODULE_FIRMWARE(). And shouldn't 'fw_data' in
fore200e_load_and_start_firmware() be a (__le32 *) not a (u32 *)?

-- 
dwmw2

