Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbXHAP0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbXHAP0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbXHAP0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:26:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:42482 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763031AbXHAP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=nCksmkSDaLsi3Dnpmo0PI9dkYqJL8r3zou+jzs8gWhatNogCgeY06GI+L9iMBSuaqpHb6DcxTxCpHHrdvvID4t8S5Joa08El0wMy1SrE7P7QSX4xEAjWFYA7owObPJmfCgnaWPFXnb0Y003kvZelHCkafDwJ/78azgJVXXE4ogo=
Message-ID: <46B0A611.3070009@googlemail.com>
Date: Wed, 01 Aug 2007 17:26:09 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
References: <46B0A3FB.2080701@googlemail.com>
In-Reply-To: <46B0A3FB.2080701@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski pisze:
> Hi,
> 
> Coding style fix
> 

Christoph Hellwig:
"There is no reason at all for a scsi driver to include stat.h"

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/mvme147.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/mvme147.c	2007-08-01 17:24:22.000000000 +0200
@@ -13,8 +13,6 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
-
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *mvme147_host = NULL;


