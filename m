Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZFLF7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZFLF7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 01:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZFLF7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 01:59:33 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:54767 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZFLF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 01:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uXOGRWnBe/z580kxTh/WRWMOFTsfGQeNlA/h4Sy3QSojIYkYVp1NG3OEkzBRw/CVna
         YKD/3A39Hi62ajNEu2dMFMn02SWC1QgFDmrT5Id8mCMVbCbuxQ+nhVtzwKZ2U48PbTO0
         9OEa4/TvbHkgwCMA8Z8E396q2Bq4QBJ2wcD8Y=
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 11:59:34 +0600
Message-ID: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
Subject: TPM drivers support and Linux Integrity Module for 2.6.30
From: Shahbaz Khan <shaz.linux@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using Intel Q45 Express chipset with TPM version 1.2 specs of
TCG. The kernel version is 2.6.30. Problem is that the TPM drivers
cannot provide functionality to the TCG TSS giving error message:

"TCSD TDDL ERROR: Could not find a device to open!"

The device node in /dev is also not being created which should be
"/dev/tpm". If created manually then still it does not work.

What should be done?

Thanks.

--
Shaz
