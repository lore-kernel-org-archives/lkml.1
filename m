Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYDFWUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYDFWUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYDFWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:19:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbYDFWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:19:54 -0400
Date: Sun, 6 Apr 2008 19:19:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB new USB ID's for 2.6.25-rc8
Message-ID: <20080406191911.68aed9c6@gaivota>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git pci_id_updates

For the following:

   - pvrusb2: add new usb pid for 73xx and 75xxx models

Those boards are about to be released by their vendor (Hauppauge). The already 
committed changes for pvrusb2 were meant to address those new devices. However, 
the vendor changed the usb sub ID's at the last moment. Those two patches adds 
the newer ID's to allow kernel to properly detect the devices.

Cheers,
Mauro.

---

 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   35 +++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

Michael Krufky (2):
      V4L/DVB (7496): pvrusb2: add new usb pid for 75xxx models
      V4L/DVB (7497): pvrusb2: add new usb pid for 73xxx models

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
