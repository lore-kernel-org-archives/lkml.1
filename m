Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYDGPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYDGPOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYDGPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:14:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:31389 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYDGPOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ns9H++tO4quy5AYLbdxsi0KTnnSUxZxfFUbe5REcgpQXkk8HT4pjLbh0bdP25h4upsNrdx9SMVofk5up94agL4zJ3O1UsU1Xh8lNIg4dBZvA/E9C/v3mxiAuHYE0VpQu1PRpgnDeq76hnnQEKkeOnnBdVtoahQWW9CRNTtpTsPI=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Ke Wei <kewei@marvell.com>
Subject: Trouble compiling kvm.git
Date: Mon, 7 Apr 2008 20:37:07 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072037.08069.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had trouble compiling kvm.git.

  LD      drivers/scsi/built-in.o
drivers/scsi/mvsas.o: In function `sas_ata_init_host_and_port':
/kernels/git/kvm/include/scsi/sas_ata.h:50: multiple definition of `sas_ata_init_host_and_port'
drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:50: first defined here
drivers/scsi/mvsas.o: In function `sas_ata_task_abort':
/kernels/git/kvm/include/scsi/sas_ata.h:54: multiple definition of `sas_ata_task_abort'
drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:54: first defined here
make[2]: *** [drivers/scsi/built-in.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

git-bisect pointed me to the following commit.

commit 0eb9ddd82a5cb08f3622345e723d236eefa0039f
Author: Ke Wei <kewei@marvell.com>
Date:   Thu Mar 27 14:53:24 2008 +0800

    [SCSI] mvsas: fill in error info record and phy mode6 bits.
    
    and remove some unused members from struct.
    
    Signed-off-by: Ke Wei <kewei@marvell.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
