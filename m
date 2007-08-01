Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbXHAPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbXHAPez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXHAPep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:34:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49055 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXHAPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=bMxuV6ajp6GiT4Am4kzC/BpyTYFojZSSrx9iVhXEOW6Xj1ZifflHhmpb8FV09KPV7Ef0b8ExsUhVYbpQE4Alt1hKlI//FU4s4KIfbq8QNE1UBYGbvjqWx+UF5AC3CfPc4UETH7vdwGOLJrbGQybYWRce/Rym3exW3RHktAylvu4=
Message-ID: <46B0A7F7.3050301@googlemail.com>
Date: Wed, 01 Aug 2007 17:34:15 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Remove stat.h from drivers/scsi/a3000.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"There is no reason at all for a scsi driver to include stat.h"
-- Christoph Hellwig

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/a3000.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/a3000.c	2007-08-01 17:32:34.000000000 +0200
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "a3000.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((a3000_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
