Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYE0TC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYE0TC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbYE0TCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:02:49 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:44908 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbYE0TCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=wOWCSsyACZloMMsT2mg7GW1cuGZaMobrQiKxaWAsCVbGGHafeDqFUrv3YYwotNuE0Hzr00pTk7BG9rkpyYCWBzSeZQk+qHVpiAwAIUAofXVsiuaB6gyl3u/kIHxlYUS7Q0+7MhSxnoSdvT4p4vrwft7fHuRZT4/QoVVQ6YIXwFs=
Date: Tue, 27 May 2008 15:02:43 -0400 (EDT)
To: scsi@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: remove CDROM not ready printk
Message-ID: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: Jerry Stralko <gerb.stralko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   This printk was spamming my dmesg and /var/log/message.  Is there a 
reason we have this printk?  Can we simply remove it?


Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
---


diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ae87d08..c37fb1c 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
  					break;
  				}
  			}
-			if (!cgc->quiet)
-				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
  #ifdef DEBUG
  			scsi_print_sense_hdr("sr", &sshdr);
  #endif
