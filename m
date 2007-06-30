Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXF3Ma1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXF3Ma1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 08:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXF3MaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 08:30:19 -0400
Received: from vz5201.evanzo-server.de ([62.67.245.201]:34892 "EHLO
	vz5201.evanzo-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXF3MaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 08:30:18 -0400
X-Greylist: delayed 1334 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jun 2007 08:30:18 EDT
Message-ID: <46864736.3090108@boneko.de>
Date: Sat, 30 Jun 2007 14:06:14 +0200
From: Tim Boneko <tim@boneko.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Old bug in tg3 driver unfixed?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I am not subscribed to this list so please CC answers to my mail
address. THX!

I recently replaced the mainboard of one of my servers with a Tyan
Tomcat K8E. The onboard gigabit NIC is a Broadcom BCM5721. After
compiling and loading the tg3 driver in Kernel 2.6.21.5, the interface
could not be configured: "Device not found".
While searching the net i found a few other people with the same problem
but no solution.

By coincidence i found that a simpe "ifconfig eth1" worked OK and
afterwards the device could be configured and used as desired. After
searching this list, i found this posting

http://uwsg.iu.edu/hypermail/linux/kernel/0409.0/0224.html

by someone with obviously the same problem.
Has some patch of the driver been reversed or is the hardware buggy?

BTW the chip is connected via PCI Express.

	timbo
