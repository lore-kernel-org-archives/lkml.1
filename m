Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYJNUjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYJNUjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYJNUjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:39:37 -0400
Received: from mail.tfh-berlin.de ([141.64.226.20]:37233 "EHLO
	mailbox2.tfh-berlin.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479AbYJNUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:39:36 -0400
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 16:39:36 EDT
Message-ID: <48F4FE60.4060102@tfh-berlin.de>
Date: Tue, 14 Oct 2008 22:17:36 +0200
From: Oliver Bock <bock@tfh-berlin.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.27: "array subscript is above array bounds" warnings
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

FYI, I just came across the following warnings when compiling 2.6.27 
(release) using gcc 4.3.2 (Debian 4.3.2-1) on Debian Lenny (i386):

----------
drivers/acpi/tables/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
include/asm/string_32.h:75: warning: array subscript is above array bounds

drivers/usb/core/hcd.c: In function ‘usb_hcd_poll_rh_status’:
include/asm/string_32.h:75: warning: array subscript is above array bounds

fs/xfs/xfs_mount.c: In function ‘xfs_mod_sb’:
fs/xfs/xfs_mount.c:1456: warning: array subscript is above array bounds
----------


Cheers,
Oliver
