Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYL3MY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYL3MY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYL3MYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:24:49 -0500
Received: from lucidpixels.com ([75.144.35.66]:35146 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYL3MYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:24:48 -0500
Date: Tue, 30 Dec 2008 07:24:47 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.28: Is there a way to disable sata probing for certain ports?
Message-ID: <alpine.DEB.1.10.0812300605250.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot from an Intel X25-E SSD, it takes roughly a few seconds; 
however, items such as:

$ dmesg|grep link\ down
[    2.447030] ata4: SATA link down (SStatus 0 SControl 300)
[    4.481288] ata5: SATA link down (SStatus 0 SControl 0)
[    6.501288] ata6: SATA link down (SStatus 0 SControl 0)
[    8.522038] ata7: SATA link down (SStatus 0 SControl 0)
[   10.552288] ata8: SATA link down (SStatus 0 SControl 0)

Scanning for devices on channels that have nothing connected adds to the 
boot time, is there anyway to turn off/disable scanning for certain ports 
to help speed the boot process?


