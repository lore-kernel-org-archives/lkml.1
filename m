Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYKCLGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYKCLGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYKCLF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:05:56 -0500
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:3366 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbYKCLFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:05:55 -0500
Subject: [PATCH 0/8] staging/wlan-ng: apply changes from wlan-ng-devel that
	get the driver working
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:05:53 +0000
Message-Id: <1225710353.3113.5.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes from wlan-ng-devel get the card in my laptop working. 
All the patches are needed to get it fully working.
Patches are against 2.6.28-rc2 + latest wlan-ng cleanup-patches

My laptop can now connected to wep enable access point under the control
of NetworkManager

Regards
Richard


Richard Kennedy (8):
  p80211netdev.c fix netdev alloc to prevent oops on device start
  prism2_usb.c always enable the card in probe_usb
  hfa384x_usb.c use newest version of 384x_drvr_start
  p80211netdev.c correctly enable wext handlers
  p80211wext.c add latest changes & remove extra nulls from wext_handlers
  p80211wext.c don't set default key id twice
  hfa384x_usb.c hfa384x_usbin_callback: check for hardware removed
  p80211conv.c copy code from wlan-ng-devel branch to not drop packets 

 drivers/staging/wlan-ng/hfa384x_usb.c  |   70 +++++++++++++++++++++++++------
 drivers/staging/wlan-ng/p80211conv.c   |   49 ++++++++++++++++++++++-
 drivers/staging/wlan-ng/p80211netdev.c |   18 ++------
 drivers/staging/wlan-ng/p80211wext.c   |   44 +++++++++++---------
 drivers/staging/wlan-ng/prism2_usb.c   |   14 ++++--
 5 files changed, 142 insertions(+), 53 deletions(-)



