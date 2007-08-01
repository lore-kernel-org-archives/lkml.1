Return-Path: <linux-kernel-owner+w=401wt.eu-S1765640AbXHAR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765640AbXHAR4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbXHAR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:56:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:37451 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095AbXHAR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FQZMDw0n2YKI5qmLnSaaPY5dUldUj0QC0jZHnGyAovAD1IuuY75NEGsHrYWKefNLaVs28JmNsOGUUk/BkjtHrqpEAIzcaSMVwngGii2GPC8AH0d6w+AK3OqSsGarAQgiCCYlGOcoIh2yJ5SBtuLxNUwXEgTtiCJ9Rjd9oh/iEGE=
Message-ID: <46B0C914.3040106@googlemail.com>
Date: Wed, 01 Aug 2007 19:55:32 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Removal of duplicated include arch/x86_64/kernel/time.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is no need to include asm/hpet.h twice

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/arch/x86_64/kernel/time.c	2007-08-01 16:40:02.000000000 +0200
+++ linux-mm/arch/x86_64/kernel/time.c	2007-08-01 18:25:10.000000000 +0200
@@ -42,7 +42,6 @@
 #include <asm/sections.h>
 #include <linux/hpet.h>
 #include <asm/apic.h>
-#include <asm/hpet.h>
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
