Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXBEFNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXBEFNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXBEFNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:13:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63437 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbXBEFNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:13:10 -0500
Date: Sun, 04 Feb 2007 23:13:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: forcedeth problems on 2.6.20-rc6-mm3
To: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>
Message-id: <45C6BCE5.90103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Something's busted with forcedeth in 2.6.20-rc6-mm3 for me relative to 
2.6.20-rc6. There's no errors in dmesg, but it seems no packets ever get 
received and so the machine can't get an IP address. I tried reverting 
all the -mm changes to drivers/net/forcedeth.c, which didn't help. The 
network controller shares an IRQ with the USB OHCI controller which is 
receiving interrupts, so it doesn't seem like an interrupt routing 
problem, though I suppose something wierd could be happening there.

This is on an Asus A8N-SLI Deluxe (CK804 chipset) on x86_64.

Any suggestions on how to debug/what to try reverting to see what's 
causing this?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
