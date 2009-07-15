Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZGOEnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZGOEnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZGOEnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:43:51 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:46860 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZGOEnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QOiOYWr3aJNycakJI3bHkSYy9faS8KS/P6YvPIJ9N81S1/+5yRqht3pYuW8qdpvu+6
         V/HmKWIVeCuY5SdYiGi522bbtGWoOCCuhS0M8yqW0rgsjHn0XMmVg0UPuGO/KRTuodZ3
         DsD2UsKhunqjdUNEd0GS92ffRWVrxLc5uy+wQ=
MIME-Version: 1.0
Date: Wed, 15 Jul 2009 10:07:10 +0530
Message-ID: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
Subject: SCSI command (SP-OUT) failing on SLES 9 32-bit
From: rohan a <info1686@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
        The SCSI command for LTO-4 drive based encryption (SPOUT
opcode = 0xB5) is failing on SLES 9 32-bit only and not on SLES 9 (64-
bit), SLES 10,11 or RHEL 4/5

Any idea why this is happening?

Error returned is : Invalid field in CDB

I am using ioctl() with the deprecated request SCSI_IOCTL_SEND_COMMAND
and not the SG3 driver.
However, only the SPOUT command is failing and none of the other SCSI
commands.
For ex: even the SPIN command (to obtain encryption status and
capabilities) works.

I even updated to SP4.

Any suggestions here?

Thanks
