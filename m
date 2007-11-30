Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbXK3IQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbXK3IQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbXK3IQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:16:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:32955 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbXK3IQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xt/GvTStIn6YvJiu9H5AGw5Zen72tNTRvG6SxBE+Y1iy/NobvpqSRL6x7rqJ8fP1DOS4YE8vmLkRKR+AVPusYg+SSJnVDMj/QIDHproMo7fDIieTUxoFZg1iYnh93MPcoGRgEneZZIwSfTZKJFG74zQBZalq2po2r5+vUl2096E=
Message-ID: <3f9a31f40711300016r30948abfp6f12e24fc39b1d62@mail.gmail.com>
Date: Fri, 30 Nov 2007 13:46:28 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [WARNINGS] 2.6.24-rc3 x86 make
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-rc3 git kernel's x86 make warnings:

1.   CC      fs/partitions/check.o
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:393: warning: ignoring return value of
'kobject_add', declared with attribute warn_unused_result
fs/partitions/check.c:396: warning: ignoring return value of
'sysfs_create_link', declared with attribute warn_unused_result
fs/partitions/check.c:403: warning: ignoring return value of
'sysfs_create_file', declared with attribute warn_unused_result
  CC      fs/partitions/ldm.o

2.  CC      drivers/pci/search.o
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:135: warning: 'pci_find_device' is deprecated
(declared at include/linux/pci.h:492)
drivers/pci/search.c: At top level:
drivers/pci/search.c:478: warning: 'pci_find_device' is deprecated
(declared at drivers/pci/search.c:283)
drivers/pci/search.c:478: warning: 'pci_find_device' is deprecated
(declared at drivers/pci/search.c:283)
drivers/pci/search.c:479: warning: 'pci_find_slot' is deprecated
(declared at drivers/pci/search.c:132)
drivers/pci/search.c:479: warning: 'pci_find_slot' is deprecated
(declared at drivers/pci/search.c:132)
  CC      drivers/pci/pci-sysfs.o

3.  CC      sound/pci/ac97/ac97_codec.o
sound/pci/ac97/ac97_patch.h:86: warning: 'snd_ac97_restore_status'
declared 'static' but never defined
sound/pci/ac97/ac97_patch.h:87: warning: 'snd_ac97_restore_iec958'
declared 'static' but never defined
  CC      sound/pci/ac97/ac97_pcm.o

Thank you,

Jaswinder Singh.
