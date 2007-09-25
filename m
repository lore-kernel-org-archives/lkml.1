Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXIYM5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXIYM5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXIYM5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:57:42 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:19863 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXIYM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lmrGn73J53aaikBeT8Dt22wjlgGql78eW2k/FBJZOK8wr8oPPSyxlM30zgT3GCYoeX8eY3bTHWn/i7MHRGhgdPSKZfWatBhV6M8Pts9z4L2iK+hLsTNMmb5Xb+pqZ9bLNmPu6rYwyKtT09BJBotC1Aoj5oWKGYdfAy8PVISN/Mo=
Date: Tue, 25 Sep 2007 20:52:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, thomas@winischhofer.net
Subject: [-mm Patch] drivers/usb/misc/sisusbvga/sisusb.c: kill two unused
	variables
Message-ID: <20070925125253.GG4945@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kill two unused variables in drivers/usb/misc/sisusbvga/sisusb.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.23-rc8-mm1/drivers/usb/misc/sisusbvga/sisusb.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/drivers/usb/misc/sisusbvga/sisusb.c
+++ linux-2.6.23-rc8-mm1/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3316,8 +3316,6 @@ static struct usb_driver sisusb_driver =
 
 static int __init usb_sisusb_init(void)
 {
-	int retval;
-	struct sisusb_usb_data *sisusb;
 
 #ifdef INCL_SISUSB_CON
 	sisusb_init_concode();
