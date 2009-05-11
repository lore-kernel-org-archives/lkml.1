Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbZEKXQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbZEKXQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZEKXQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:16:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZEKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:16:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: libsas depends on HAS_DMA
Date: Mon, 11 May 2009 23:16:20 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20090511222702.352192505@arndb.de> <1242082233.27353.9.camel@mulgrave.int.hansenpartnership.com> <1242082784.27353.13.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1242082784.27353.13.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905112316.20574.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18wTF1uqgdyXvCuT62ELHNXpFYEPAK5Rp07Saq
 iZNmoYKYwgTUgYGV9xEvlbP4G9xXAbe/+38ldJu1iHLyPz7+b2
 Kyl+dDYz27gn3bbC9sGEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009 22:59:44 James Bottomley wrote:
> Actually, looking at this further, the problem is only in the ata
> compatibility layer because of the way libata does dma mapping on behalf
> of drivers, so the solution below (just disable SATA support if HAS_DMA
> isn't defined) will work without requiring select dependency
> modification.

Ah, in that case, the patch should not be needed at all, because
SCSI_SAS_ATA already depends on ATA, and I also submitted a patch
to make ATA depend on HAS_DMA.

Thanks for looking at it.

	Arnd <><
