Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbXKRVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbXKRVkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXKRVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:40:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:55551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbXKRVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Jz9xgwC5cej+xSKSVRtm9vu/SXr7Qdr/Nwh2NGpy3dYSeXmqyGtpqUgJVsciM7XyJAtMfzpB6G0zbh2G9Ay4VVtUyO3TCmCzgEpnydODJ+Rm5wngNN3sP91FUDaP9B+wGR4qRYa9NhWAnWoLRMMsQGBChwdbDLXnPbULQiALXH8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonas Stare <jonas.stare@purplescout.se>
Subject: Re: [PATCH] drivers/ide/ide-probe.c Skip ide_wait_not_busy on noprobe-disks. was: [PATCH][RESUBMIT] drivers/ide/ide-probe.c, kernel 2.6.23.1
Date: Sun, 18 Nov 2007 22:39:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
References: <473434F1.50509@purplescout.se> <200711162222.54847.bzolnier@gmail.com> <473E2049.4070806@purplescout.se>
In-Reply-To: <473E2049.4070806@purplescout.se>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711182239.33274.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007, Jonas Stare wrote:
> There is a problem in some hardware where the kernel will stall for
> 35 seconds waiting for disks that dont exist. This patch will skip
> waiting for the BSY-bit on ide-drives to go away if you set
> hdx=noprobe as a kernel option and the disk is not marked
> as 'present' (like when you set the geometry by hand).
> 
> If no noprobe-option is set the code will work (more or less) as the 
> original but if set the code will skip the ide_wait_not_busy() for that 
> drive. Even if there would be a drive there and it is still BSY 
> afterwards it should not matter since it isn't probed for later.
> 
> (The code also honors the MAX_DRIVES variable instead of assuming that 
> there will be two harddrives on the bus.)
> 
> 
> Signed-off-by: Jonas Stare <jonas.stare@purplescout.se>

Thanks!

PS There were still some whitespace problems (all tabs were replaced by
spaces) so I just applied it by hand (and made few minor cleanups while
at it).

Bart
