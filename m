Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYADBVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYADBVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbYADBTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:60452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYADBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=piHiBT2FUkrvghwQTATKbiDYwFZbFNLHdr3GowGikwGa/4S3REiCJSN89dEjIR3K+yM9lE0LZBrcIs0dO4GNg/S5Yl3nTlfcwpSoPv6UCY3mUv3E3mdIoLpcginjVTTquJ6l2h2emQUjRxHuKu422kWwSRFQDrI5YZlE07d8HZg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 10/10] ide-floppy: replace ntoh{s,l} and hton{s,l} calls with the generic byteorder macros
Date: Fri, 4 Jan 2008 02:29:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-11-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-11-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801040229.04956.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

minor thing:

WARNING: line over 80 characters
#88: FILE: drivers/ide/ide-floppy.c:759:
+               put_unaligned(cpu_to_be16(blocks), (unsigned short *) &pc->c[7]);

seems like it can be fixed by removing space between '(unsigned short *)'
and '&pc->c[7]'

otherwise looks good, please move it at the beginning of the patch series

PS I need some sleep so the rest of patches have to wait till tomorrow...
