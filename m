Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXJDSEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXJDSEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXJDSEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:04:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56801 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbXJDSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:04:16 -0400
Date: Thu, 4 Oct 2007 20:04:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Finding a free range (idr, blockdev)
Message-ID: <Pine.LNX.4.64.0710041957500.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I'd like to register a blkdev region, much like

	blk_register_region(MKDEV(major, first_minor), number_minors, 
		            xmodule, xprobe, xlock, xdata);

number_minors is known, but how do I decide what first_minor to use?
Module owns the full major number, so I thought I could use an idr map,
but there does not seem to be a function that marks a range used.
(Something along idr_get_new_range(&my_idr, ptr, &new_id, range_len)
would have been cool.)
Ideas on how to proceed?


Thanks,
Jan
