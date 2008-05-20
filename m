Return-Path: <linux-kernel-owner+w=401wt.eu-S1765666AbYETLD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765666AbYETLD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYETLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:02:55 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46502 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763540AbYETLCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:02:54 -0400
X-Greylist: delayed 3151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 07:02:53 EDT
Message-ID: <48003.145.64.134.222.1211278220.squirrel@www.hardeman.nu>
Date: Tue, 20 May 2008 12:10:20 +0200 (CEST)
Subject: Loading DSDT from initrd, can it be done from grub instead?
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47 the
ACPI_CUSTOM_DSDT_INITRD option was removed.

I was wondering if it'd be feasible to hack grub to load a custom DSDT
instead (since grub can read filesystems) and then pass a pointer to a
memory location containing the DSDT to the kernel?

-- 
David Härdeman

