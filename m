Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZLRTgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZLRTgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZLRTgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:37 -0500
Received: from kroah.org ([198.145.64.141]:47430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZLRTga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:30 -0500
Subject: patch staging-slicoss-check-for-valid-hw-address.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:52 -0800
In-Reply-To: <20091218075245.GA4504@coldcone>
Message-ID: <12611648323235@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Check for valid hw address

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-check-for-valid-hw-address.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:33:05 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 10:52:45 +0300
Subject: staging: slicoss Check for valid hw address
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218075245.GA4504@coldcone>


Check for valid hw address.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/slicoss/slicoss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2531,6 +2531,9 @@ static int slic_mac_set_address(struct n
 	if (!adapter)
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EINVAL;
+
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
 	memcpy(adapter->currmacaddr, addr->sa_data, dev->addr_len);
 

