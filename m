Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYLaMI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYLaMI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYLaMH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:07:58 -0500
Received: from aun.it.uu.se ([130.238.12.36]:43918 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841AbYLaMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:07:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18779.24723.646720.252479@harpo.it.uu.se>
Date: Wed, 31 Dec 2008 13:07:47 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jan De Luyck <ml_linuxkernel_20080830@kcore.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 - cannot find root fs on Acer TM 291 (ICH4-M)
In-Reply-To: <495B5ABD.7040909@kcore.org>
References: <495B5ABD.7040909@kcore.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan De Luyck writes:
 > Hello list,
 > 
 > I've been a happy user on my desktop system of 2.6.28 since it's been released,
 > but I seem to have hit a snag on my laptop. Can't get it to boot, keeps
 > panicking with a VFS: cannot open root device "hda3" or unknown-block(0,0)
 > 
 > I've tried several configurations, starting off the last kernel built for the
 > machine (2.6.25.16). I've selected the PIIX IDE driver (no SATA here), tried
 > with and without the advanced partition schemes, but I can't get it to boot.
...
 > #
 > # Automatically generated make config: don't edit
 > # Linux kernel version: 2.6.28
 > # Wed Dec 31 11:46:21 2008
...
 > CONFIG_HAVE_IDE=y
 > CONFIG_IDE=y
 > 
 > #
 > # Please see Documentation/ide/ide.txt for help/info on IDE drives
 > #
 > CONFIG_IDE_ATAPI=y
 > # CONFIG_BLK_DEV_IDE_SATA is not set
 > # CONFIG_IDE_GD is not set

You need to enable IDE_GD and IDE_GD_ATA.

But I recommend that you switch to libata instead (with ata_piix driver).
