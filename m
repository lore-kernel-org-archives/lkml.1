Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXCECXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXCECXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXCECXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:23:19 -0500
Received: from canuck.infradead.org ([209.217.80.40]:46256 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXCECXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:23:16 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: "'Richard Purdie'" <rpurdie@openedhand.com>,
       "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'kernel list'" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>
References: <1172850902.11149.130.camel@localhost.localdomain>
Subject: RE: [PATCH 8/9] mtd: Allow mtd block device drivers to have a custom	ioctl function
Date: Mon, 5 Mar 2007 11:23:05 +0900
Message-ID: <009601c75ecd$37b4c950$c7a3580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1172850902.11149.130.camel@localhost.localdomain>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: Acdc5P4sqkTSTRQ5TdS9Ae504+tsoQB5LUUw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To make a modules, we have to export "get_mtd_blktrans_gendisk".

"get_mtd_blktrans_gendisk" is used at mtdswap.

>  
> +struct gendisk *get_mtd_blktrans_gendisk(struct 
> mtd_blktrans_dev *dev)
> +{
> +	return dev->blkcore_priv;
> +}
> +

@@ -469,6 +480,7 @@ EXPORT_SYMBOL_GPL(register_mtd_blktrans);
 EXPORT_SYMBOL_GPL(deregister_mtd_blktrans);
 EXPORT_SYMBOL_GPL(add_mtd_blktrans_dev);
 EXPORT_SYMBOL_GPL(del_mtd_blktrans_dev);
+EXPORT_SYMBOL_GPL(get_mtd_blktrans_gendisk);

 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_LICENSE("GPL");

Thank you,
Kyungmin Park

