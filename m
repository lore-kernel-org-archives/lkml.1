Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXC0QZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXC0QZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbXC0QZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:25:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:26265 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXC0QZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:25:09 -0400
X-AuditID: d80ac287-91f24bb000000c42-43-460945642c85 
Date: Tue, 27 Mar 2007 17:25:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: CONFIG_SCSI_WAIT_SCAN=m
Message-ID: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 27 Mar 2007 16:25:06.0246 (UTC) FILETIME=[7ADE2660:01C7708C]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not using an initrd, most of my kernel is builtin,
just a few modules for occasional filesystems.

CONFIG_MODULES=y
CONFIG_SCSI=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2,
but boots okay if I change drivers/scsi/Kconfig to "default y"
instead of "default m" for SCSI_WAIT_SCAN.

I'm sure that's not the right fix, but I don't know what is.

I've had no trouble with SCSI_SCAN_ASYNC=y until now: I could
turn it off, but others may have trouble with the same regression.

Hugh
