Return-Path: <linux-kernel-owner+w=401wt.eu-S1765599AbXHAPkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765599AbXHAPkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbXHAPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:40:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53661 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbXHAPj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=GiQhY21K86B4lkYluQtS35zyy2Rq0GebIyf/loHRI3dqkMdX0XlQZLDO+vZCzo9AXfFdevPbW1cJ5cJwojuRtIPhD21I7ffSPne6H6TtJIm8kgD33xwDf4OTZWakNFtEb/cfZvMrZOsgooAvtgeMVkgs+oBnlH/SFuMdp/ixk3A=
Message-ID: <46B0A931.9070209@googlemail.com>
Date: Wed, 01 Aug 2007 17:39:29 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Remove stat.h from drivers/scsi/gvp11.c
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

--- linux-mm-clean/drivers/scsi/gvp11.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/gvp11.c	2007-08-01 17:36:45.000000000 +0200
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "gvp11.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((gvp11_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
