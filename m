Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXK3IPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXK3IPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXK3IPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:15:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:29924 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbXK3IO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZZhxHUGJxMHo+Og4W1fDl/SSEAXb9XLVRJ4O3FR215PnIAfcpuSZOux1xno9VHnTgwX0bsXbd7VY6bS1iAkvDaDCLcAgR2f/CuNI/eDkow/+Id7g7NOj+Q6FmosvAKx6OWcEfNc1MZRDnHx7N180yb5YnVvftKg9NPWt9AMaXDQ=
Message-ID: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
Date: Fri, 30 Nov 2007 13:44:56 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-rc3 git kernel's x86 make depends on s390 arch:

1.   HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
drivers/crypto/Kconfig:51: can't open file "arch/s390/crypto/Kconfig"
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2

2.  CC      kernel/sysctl_check.o
kernel/sysctl_check.c:3:44: error: ../arch/s390/appldata/appldata.h:
No such file or directory
make[1]: *** [kernel/sysctl_check.o] Error 1
make: *** [kernel] Error 2

Thank you,

Jaswinder Singh.
