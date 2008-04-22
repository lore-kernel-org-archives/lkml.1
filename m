Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYDVQVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYDVQVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYDVQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:21:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49517 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYDVQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:21:21 -0400
Message-ID: <28221442.1208881240429.JavaMail.oracle@acsmt302.oracle.com>
Date: Tue, 22 Apr 2008 11:20:40 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: linux-kernel@vger.kernel.org
Subject: pasic3 allmod/yesconfig build error
Cc: linux@arm.linux.org.uk, philipp.zabel@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allmodconfig and allyesconfig on $ARCH try to build the htc-pasic3 driver, but
it fails due to wanting <asm/arch/pxa-regs.h>.

Should the Kconfig file be modified to build this driver only for $ARCH=arm ?

---
~Randy

