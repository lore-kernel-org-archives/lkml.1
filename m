Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbXBCNjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbXBCNjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXBCNjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:39:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:1375 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXBCNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=l8xSVCzryJTWuYELkiQ5W7tqgPb4lL+eFLJhQRhrPmyGu2ktvbXuswUOihcxfptePT8sGmA0dfRcemiFJBEd0OzUOfiwqK/jqtdithF11N8ZSkP74Q/h0qGz9yNt8iQrnwHKmMH9378cQoKVbx1wbbbMa9ahn0HvMIcXNNCR6wY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 03 Feb 2007 14:44:11 +0100
Message-Id: <20070203134411.2491.57713.sendpatchset@localhost.localdomain>
Subject: [ANNOUNCE] IDE quilt tree updated
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've just updated IDE quilt tree:
	http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/


New patches:

* ide-floppy: Fix unformatted media crash
  (Alan Cox <alan@redhat.com>)

* ide: clear bmdma status in ide_intr() for ICHx controllers (revised #4)
* ide: remove clearing bmdma status from cdrom_decode_status() (rev #4)
  (Albert Lee <albertcc@tw.ibm.com>)

* siimage: PIO1/2 taskfile transfer overclocking fix
* pdc202xx_old: fix PIO mode setup
* sl82c105: DMA support fixes
  (Sergei Shtylyov <sshtylyov@ru.mvista.com>)

+ some patches got fixed according to the feedback from Sergei

Also the order of the patches in the series file was changed to be more
like this: fixes first, then new drivers/features and cleanups at the end.

diffstat:
 62 files changed, 3349 insertions(+), 2496 deletions(-)

If you would like to see the full quilt series (or to get combined patch)
against 2.6.20-rc7, they are available here:

       http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/releases/

Oh, and IDE tree TODO is now available here:

	http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/TODO

Thanks,
Bart
