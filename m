Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXHAPXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXHAPXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbXHAPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:23:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:38918 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbXHAPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=oKP54teXpjUj7nsZvkH7JtFBIFRIYyAf35zYvwNKvAgcDubhQGt/uykUcf5dJ5AgvJvJRtqqjW5uhGvXcltsISknJgJ3vxizIxPu7G7TjzmvCFXWU684wmeEU4lnSW9Gz9f9r8kzTg0AIYtam77SMzVal31wO+qWzqq3raVsPL4=
Message-ID: <46B0A537.9070907@googlemail.com>
Date: Wed, 01 Aug 2007 17:22:31 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
References: <46B0A30A.8090500@googlemail.com> <20070801151812.GA17601@infradead.org>
In-Reply-To: <20070801151812.GA17601@infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig pisze:
> On Wed, Aug 01, 2007 at 05:13:14PM +0200, Michal Piotrowski wrote:
>> Hi,
>>
>> Coding style fix
>>
>> Regards,
>> Michal
>>
> 
> I think that include should just go.  There is no reason at all for
> a scsi driver to include stat.h
> 
> 

As you wish

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/aha1542.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/aha1542.c	2007-08-01 17:18:57.000000000 +0200
@@ -77,8 +77,6 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-#include<linux/stat.h>
-
 #ifdef DEBUG
 #define DEB(x) x
 #else

