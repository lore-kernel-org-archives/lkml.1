Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZFST3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZFST3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZFST3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:29:45 -0400
Received: from deluge.CC.McGill.CA ([132.206.27.50]:38635 "EHLO
	deluge.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZFST3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:29:44 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 15:29:44 EDT
Subject: Panic booting 2.6.30
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Fri, 19 Jun 2009 15:23:24 -0400
Message-Id: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.6.19.114543
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just upgraded an older machine (a P3 running slackware 11.0) from
2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
lilo) I get:

VSF:  Cannot open root device "hda2" or unknown-block(0,0)
Please append a correct root= boot option; here are the available
partions:     <====== nothing shows here...
Kernel-Panic - not syncing.

I had rebooted with and without root=hda2.   The old kernel is still
usable.

Lilo.conf looks like:

boot = /dev/hda
lba32
message = /boot/boot_message.txt
prompt
timeout = 300
vga = normal
# Linux bootable partition config begins
image = /bzImage-2.6.30
  root = /dev/hda2
  label = Linux-2.6.30
  read-only
# Linux bootable partition config ends
# Linux bootable partition config begins
image = /bzImage-2.6.26.5
  root = /dev/hda2
  label = Linux-2.6.26.5
  read-only
# Linux bootable partition config ends
# Linux bootable partition config begins
image = /memtest86
  root = /dev/hda2
  label = memtest86
  read-only
# Linux bootable partition config ends

Any ideas?  Please CC me directly.

Thanks in advance

David

