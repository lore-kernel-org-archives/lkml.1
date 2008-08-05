Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbYHEPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbYHEPbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbYHEPa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:30:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:11424 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbYHEPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=I6JZkY/o/HLBQ9WoFjx6Im7qsqM6FXE8wmk9VbTZ3iFYfrQwQPFnT7NVfSZOGmgnKI
         89MxsqkorzHzpdcM0k3UoxesvLOhFAugE/BBYsGdO1+3f1xpqCpuCmhZtnb1RLERTrlI
         d0ooCtRljGi5kvxQYIlEBY+mAA1YcdFbP6PAc=
From: Alessandro Guido <alessandro.guido@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: "e100_probe: Error clearing wake event" when booting 2.6.27-rc1
Date: Tue, 5 Aug 2008 17:30:26 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-00649-gca5de40; KDE/4.1.0; i686; ; )
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051730.27599.alessandro.guido@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc me on replies]

I'm getting this error message when booting my laptop.

The commit that causes this is:

commit eb9d0fe40e313c0a74115ef456a2e43a6c8da72f
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jul 7 03:34:48 2008 +0200

    PCI ACPI: Rework PCI handling of wake-up

[very long commit message snipped]

Should I ignore that?
