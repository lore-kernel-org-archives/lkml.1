Return-Path: <linux-kernel-owner+w=401wt.eu-S936382AbYBCJkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936382AbYBCJkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbYBCJjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:39:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbYBCJjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:39:54 -0500
Message-ID: <47A58B05.6010702@oracle.com>
Date: Sun, 03 Feb 2008 17:36:05 +0800
From: Wenji Huang <wenji.huang@oracle.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.4.1 (X11/20060420)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: LPFC compilation error in 2.6.24-git12/git13
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 Found compilation error in 2.6.24-git12/git13:

  CC [M]  drivers/scsi/lpfc/lpfc_mem.o
  CC [M]  drivers/scsi/lpfc/lpfc_sli.o
  CC [M]  drivers/scsi/lpfc/lpfc_ct.o
  CC [M]  drivers/scsi/lpfc/lpfc_els.o
  CC [M]  drivers/scsi/lpfc/lpfc_hbadisc.o
  CC [M]  drivers/scsi/lpfc/lpfc_init.o
drivers/scsi/lpfc/lpfc_init.c: In function ‘lpfc_pci_probe_one':
drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration of 
function ‘pci_enable_device_bars'
make[3]: *** [drivers/scsi/lpfc/lpfc_init.o] Error 1
make[2]: *** [drivers/scsi/lpfc] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

pci_enable_device_bars is removed in commit 
215e871aaa3d94540121a3809d80d0c5e5686e4f.

Regards,
Wenji
