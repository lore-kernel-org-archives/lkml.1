Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbXH2J0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbXH2J0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXH2J0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:26:47 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:33187 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXH2J0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:26:46 -0400
Date: Wed, 29 Aug 2007 17:56:14 +0900 (JST)
Message-Id: <20070829.175614.-1300543370.kouish@swc.toshiba.co.jp>
To: krafft@de.ibm.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jk@ozlabs.org, cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [patch 1/5] spu_manage: use newer physical-id
In-Reply-To: <20070828162011.5356afaa@localhost>
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christian Krafft wrote:
> On Thu, 23 Aug 2007 18:12:19 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Thursday 23 August 2007, kou.ishizaki@toshiba.co.jp wrote:
> > > Please check "unit-id" if "physical-id" doesn't exist. Because
Celleb
> > > uses "unit-id" to provide spe_id.
> 
> Sorry for the late answer, wasn't on cc
> and had to receive all mails of the last 6 month once again :-(
> 
> Can you check if the patch below is working with celleb device tree ?
> 
> ------
> Subject: spu_manage: fix spu_unit_number for celleb device tree
> 
> From: Christian Krafft <krafft@de.ibm.com>
> 
> New device trees provide "physical-id".
> Celleb device tree provide the "unit-id".
> Legacy device tree used the reg property for the physical id of an
spe.
> This patch fixes find_spu_unit_number to look for the spu id in that
order.
> The length is checked to avoid misinterpretation in case the
attributes
> unit-id or reg do not contain the id.
> 
> Signed-off-by: Christian Krafft <krafft@de.ibm.com>

Acked-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

It works good on Celleb, thanks.  Please apply it to 2.6.23.

Best regards,
Kou Ishizaki
