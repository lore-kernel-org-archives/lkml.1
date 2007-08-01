Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbXHAR54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbXHAR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbXHAR5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:57:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:38671 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXHAR5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=VVSewkaXFL3gO2oRKK3yiLjEeBjzUt/Ezx2ZN7BV1YW5n+7cP22jmLQwKJphPyEUywACSKgRT3mAjT6LxZHeYM3nV4ODx9BCNlzq9vcMcT5dMHkq/lR+LASMLUOImoUiI9roXEkOZzFSkkxGOaYVxx5r4+BB82cEJlPZ5hhhUmw=
Message-ID: <46B0C97A.4030806@googlemail.com>
Date: Wed, 01 Aug 2007 19:57:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Removal of duplicated include arch/x86_64/vdso/vclock_gettime.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is no need to include asm/vgtod.h twice

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/arch/x86_64/vdso/vclock_gettime.c	2007-08-01 16:39:29.000000000 +0200
+++ linux-mm/arch/x86_64/vdso/vclock_gettime.c	2007-08-01 18:21:29.000000000 +0200
@@ -19,7 +19,6 @@
 #include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
-#include <asm/vgtod.h>
 #include "vextern.h"
 
 #define gtod vdso_vsyscall_gtod_data
