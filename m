Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbXKSV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbXKSV5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXKSV4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:56:22 -0500
Received: from v1539.ncsrv.de ([89.110.150.23]:57713 "EHLO v1539.ncsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbXKSV4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:56:21 -0500
Message-Id: <20071119211318.046166499@hendrik-sattler.de>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 22:13:18 +0100
From: post@hendrik-sattler.de
To: linux-kernel@vger.kernel.org
Cc: i2c@lm-sensors.org
Subject: [PATCH 0/2] FSC Lifebook panel button support
X-Spam-Score: -3.5 (---)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a kind of ongoing project to support the panel buttons in
FSC Lifebook laptops. This is another approach since the apanel driver
does not work for me. They are partly similar, though.
It seperates I2C chip support from the handling of the table
information. That improves readability a lot (at least for me) and
allows one driver per chip and reusability of those drivers.
The components include:
  * the oz99x driver to make the buttons on a Lifebook C-6637 work
  * the fjkeyinf driver to read the BIOS table information

The oz99x driver is independent of the fjkeyinf driver.
-- 

