Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896Ab0AGKRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0AGKRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509Ab0AGKQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:16:59 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:52406 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0AGKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:16:58 -0500
Message-ID: <4B45B496.90907@mandriva.org>
Date: Thu, 07 Jan 2010 12:16:54 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100104 Mandriva/3.0-5mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: james.smart@emulex.com, James.Bottomley@suse.de,
       torvalds@linux-foundation.org
Subject: latest git pull changed drivers/scsi/lpfc/lpfc_hw4.h to executable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At latest pull, lpfs_hw4.h got set to executable...

git show def9c7a994f194377a23e687e6fd39b46c3ce631 --summary

states:

commit def9c7a994f194377a23e687e6fd39b46c3ce631
Author: James Smart <james.smart@emulex.com>
Date:   Mon Dec 21 17:02:28 2009 -0500

     [SCSI] lpfc 8.3.7: Fix hardware/SLI relates issues

     Fix hardware/SLI relates issues:
     - Fix CNA uses more than one EQ when in INTx interrupt mode.
     - Fix driver tries to process failed read FCF record mailbox request.
     - Fix allocating single receive buffer breaks FCoE receive queue.
     - Support new read FCF record mailbox error case.

     Signed-off-by: James Smart <james.smart@emulex.com>
     Signed-off-by: James Bottomley <James.Bottomley@suse.de>

  mode change 100644 => 100755 drivers/scsi/lpfc/lpfc_hw4.h


While looking at the same tree, I also noticed that:
drivers/scsi/lpfc/lpfc_hbadisc.c is also executable.

I guess they should be fixed.

--
Thomas

