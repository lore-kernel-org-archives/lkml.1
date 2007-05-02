Return-Path: <linux-kernel-owner+w=401wt.eu-S2993269AbXEBOoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993269AbXEBOoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993270AbXEBOoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:44:01 -0400
Received: from ozlabs.org ([203.10.76.45]:33496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993269AbXEBOoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:44:00 -0400
Subject: [RELEASE] Lguest for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 03 May 2007 00:43:48 +1000
Message-Id: <1178117028.19815.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	Lguest is a simple hypervisor which runs Linux under Linux, without
needing VT hardware.

	Two people asked if I had a version of lguest which worked on
other-than-bleeding-edge-mm kernels, so I did a backport of the latest
version to 2.6.21.

	http://lguest.ozlabs.org/lguest-2.6.21-254.patch.gz

See Documentation/lguest/lguest.txt for how to run,
drivers/lguest/README for the draft code documentation journey.

Bug or even success reports always welcome!
Rusty.


Quickstart:

$ cd linux-2.6.21
$ zcat /tmp/lguest-2.6.21-254.patch.gz | patch -p1
$ make
	- Say "y" to CONFIG_EXPERIMENTAL, "m" to CONFIG_LGUEST.
$ make modules_install
$ make -C Documentation/lguest
$ sudo Documentation/lguest/lguest --block=<some-convenient-raw-image> \
	128 vmlinux root=/dev/lgba

Three ^C's within one second will kill the guest.



