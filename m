Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbXCDHfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbXCDHfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 02:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXCDHfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 02:35:20 -0500
Received: from em.volia.net ([82.144.192.9]:62197 "EHLO em.volia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXCDHfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 02:35:19 -0500
X-Greylist: delayed 64735 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 02:35:19 EST
From: Nick Shaforostoff <shafff@ukr.net>
Organization: National Technical University of Ukraine
To: linux-kernel@vger.kernel.org
Subject: usbnet bug in 2.6.20.1
Date: Sat, 3 Mar 2007 15:36:40 +0200
User-Agent: KMail/1.9.5
X-Face: russian
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-u"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703031536.41877.shafff@ukr.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

after upgrading from 2.6.15 to 2.6.20.1 i got problem with my usb modem (terayon).
kern.log it said:
usb 3-1: new full speed USB device using ohci_hcd and address 2
usb 3-1: no configuration chosen from 1 choice


my solution was to 
replace
#ifndef CONFIG_USB_NET_RNDIS_HOST
with 
#ifndef CONFIG_USB_NET_RNDIS_HOST_MODULE
in drivers/usb/core/generic.c



-- 
Some men see things as they are and say, "Why?" I dream of things that never were and say, "Why not?"
 --George Bernard Shaw
