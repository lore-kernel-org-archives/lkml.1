Return-Path: <linux-kernel-owner+w=401wt.eu-S932297Ab0A1Sof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0A1Sof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332Ab0A1Soe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:44:34 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:45793 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab0A1Sod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lAdt7o8bIylcmAuKCiZZ5gz3xqXsgDIRm8OH5cG4Qt61Zplsxa9HDSqL7Ov6C/WaCX
         DqTWkMBKDF5se+K7tJt1bM7IS1A07Ezay9yWNX3EOhVEVjFRyM0KUYYPewVz/JeqO09A
         lFuMwtO4zENbBUwQY7SoY9Ijk6CUUEQu7XlJg=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 02:44:32 +0800
Message-ID: <8e678d3f1001281044xb0a4be6n32383971ee5be101@mail.gmail.com>
Subject: [kernel build bug]
From: Robin Steven <armrobin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I am hacking TPS65930 codec driver for my OMAP3 based board, start at
git tag v2.6.31.
I can not find option to build the twl4030 codec driver
(CONFIG_SND_SOC_TWL4030) in menuconfig interface,
after I set the CONFIG_SND_SOC as "M", the CONFIG_SND_SOC_TWL4030 will
be set as module automatically.
while I run `make uImage && make modules`, build process arise error:

ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!

It's a bug?

Robin
