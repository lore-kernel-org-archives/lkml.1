Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbXJPNCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbXJPNCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXJPNCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:02:35 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:60447 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437AbXJPNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:02:34 -0400
Date: Tue, 16 Oct 2007 14:02:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-mips@linux-mips.org
Subject: Build breakage if !SYSFS
Message-ID: <20071016130231.GA10778@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changeset 5cb350baf580017da38199625b7365b1763d7180 causes build breakage
if sysfs support is disabled:

kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1488): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1490): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1480): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1494): undefined reference to `kernel_subsys'

This breaks for example mipssim_defconfig.

  Ralf
