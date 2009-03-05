Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZCEQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZCEQUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZCEQUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:20:03 -0500
Received: from mail-fx0-f168.google.com ([209.85.220.168]:32879 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZCEQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=EsvyacqeeHY0r3UeV+aRrJ9MglJNDtZ7G6iDk0LczzBP4GriJpXdpxFz2mDrxggOuK
         CoKLa8q5x0RJA5lbE6o2E7uooT8oIcWtfK2ZhnFDhxRz4jdRGeyokji79AR4JYisJB96
         Ue927MjXQeK+E3nJssb96R7/Q7mnHiR7MOtxU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: add CFA specific identify data words
Date: Thu, 5 Mar 2009 17:20:23 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, sshtylyov@ru.mvista.com,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090305154040.GA23182@havoc.gtf.org>
In-Reply-To: <20090305154040.GA23182@havoc.gtf.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903051720.24108.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Jeff Garzik wrote:
> From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> Declare and use constants for CFA specific identify data words 162 and 163.
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> ---
> Sergei said:
> This patch is against the current pata-2.6 series. I'd prefer that Bart merged
> it thru his tree as my next patch adding CF mode support to IDE depends on it.
> 
> jgarzik adds:
> I didn't see this in your latest submission, Bart.  It is simple and

Simply because I haven't yet got to those patches + Sergei mentioned
that they need to be tested yet.

> harmless and might as well go ahead upstream, to eliminate the
> cross-tree dependency that Sergei speaks of (his patch also touched
> drivers/ata/libata-core.c, but I excluded that from below).

Fine with me if this makes things easier for everyone.

I updated git pull request with this patch fixing patch summary
(this is not libata specific change) and patch description (constants
are not currently unused) while at it.

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] ata: add CFA specific identify data words

Declare CFA specific identify data words 162 and 163 for future use.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
[bart: update patch summary/description]
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ata.h       |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: linux-2.6/include/linux/ata.h
===================================================================
--- linux-2.6.orig/include/linux/ata.h
+++ linux-2.6/include/linux/ata.h
@@ -89,6 +89,8 @@ enum {
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
 	ATA_ID_CFA_POWER	= 160,
+	ATA_ID_CFA_KEY_MGMT	= 162,
+	ATA_ID_CFA_MODES	= 163,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
