Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXCISEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXCISEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXCISEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:04:30 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:9628 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXCISE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:04:27 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
Organization: IBM Corporation
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ibmebus: uevent support
Date: Fri, 9 Mar 2007 19:01:29 +0100
User-Agent: KMail/1.6.2
Cc: pmac@au1.ibm.com, hnguyen@de.ibm.com, johnrose@austin.ibm.com,
       johnrose@us.ibm.com, nfont@austin.ibm.com, paulus@samba.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703091901.29133.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds uevent support to ibmebus using the generic of_device_uevent()
function.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


I split this change into a separate patch because it depends on another
patch against 2.6.20, submitted by Sylvain Munaut:
http://patchwork.ozlabs.org/linuxppc/patch?id=9558


 ibmebus.c |    1 +
 1 file changed, 1 insertion(+)


diff -Nurp 03.almost-all/arch/powerpc/kernel/ibmebus.c 04.uevent/arch/powerpc/kernel/ibmebus.c
--- 03.almost-all/arch/powerpc/kernel/ibmebus.c	2007-03-09 17:37:08.309979440 +0100
+++ 04.uevent/arch/powerpc/kernel/ibmebus.c	2007-03-07 19:07:53.000000000 +0100
@@ -460,6 +460,7 @@ static struct bus_attribute ibmebus_bus_
 
 struct bus_type ibmebus_bus_type = {
 	.name      = "ibmebus",
+	.uevent    = of_device_uevent,
 	.match     = ibmebus_bus_match,
 	.dev_attrs = ibmebus_dev_attrs,
 	.bus_attrs = ibmebus_bus_attrs

