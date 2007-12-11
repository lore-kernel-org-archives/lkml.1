Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbXLKWVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbXLKWVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbXLKWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:20:57 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38479 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755806AbXLKWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:20:56 -0500
Date: Tue, 11 Dec 2007 23:20:55 +0100
From: Adrian Bunk <bunk@kernel.org>
To: James Smart <James.Smart@emulex.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: scsi/lpfc/lpfc_attr.c: bogus code
Message-ID: <20071211222055.GE14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e0fef85e098f6794956b8b80b111179fbb4cbb7 added the folowing code 
to drivers/scsi/lpfc/lpfc_attr.c that was most likely not intended to be 
dead code:

<--  snip  -->

...
lpfc_state_show(struct class_device *cdev, char *buf)
{
...
                switch (vport->port_state) {
                        len += snprintf(buf + len, PAGE_SIZE-len,
                                        "initializing\n");
                        break;
...

<--  snip  -->

Spotted by the GNU C compiler version 3.3.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

