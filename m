Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYGBSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYGBSgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYGBSgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:36:12 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:53046 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYGBSgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:36:12 -0400
Message-ID: <486BCA98.8050806@linux.vnet.ibm.com>
Date: Wed, 02 Jul 2008 15:36:08 -0300
From: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] add types.h include to dasd.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dasd.h uses __u16 and __u8 types but doesn't include linux/types.h.
It fixes probable compiler errors if dasd.h is the first/unique included file.
Thanks.

Signed-off-by: Edjunior B. Machado <emachado@linux.vnet.ibm.com>
---
include/asm-s390/dasd.h |    1 +
1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-s390/dasd.h b/include/asm-s390/dasd.h
index 3f002e1..d5a191a 100644
--- a/include/asm-s390/dasd.h
+++ b/include/asm-s390/dasd.h
@@ -13,6 +13,7 @@
#ifndef DASD_H
#define DASD_H
#include <linux/ioctl.h>
+#include <linux/types.h>

#define DASD_IOCTL_LETTER 'D'

-- 
Edjunior Barbosa Machado
IBM Linux Technology Center
Linux Defect Support Team

