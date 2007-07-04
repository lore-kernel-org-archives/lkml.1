Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXGDNxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXGDNxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXGDNxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:53:10 -0400
Received: from mail03.hansenet.de ([213.191.73.10]:34559 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759122AbXGDNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:53:09 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 09:53:09 EDT
Message-ID: <468BA187.3080703@e-dict.net>
Date: Wed, 04 Jul 2007 15:32:55 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: md device files missing at boot time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

one of the systems I'm working with was changed (copied) from single (scsi - sda1)
to multiple disk (raid1) (sdb1,sdc1 --> md0).
When I try to boot from the new created md-device it stops with:
...
loading reiserfs
"Waiting for device /dev/md0 to appear: ........ not found -- Exiting to /bin/sh

A
# ls -la /dev/md*
shows nothing, so I understand why the "/" cannot be mounted, but
where are the /dev/md* files (I found them in "/lib/udev/devices")?

The kernel is vanilla 2.6.21.5, the (I think) needed hardware and filesystem
drivers are built in modules and put into an initrd file for loading at boot time.

Does anyone have an idea what I might do wrong?

Thanks - Ingo.
