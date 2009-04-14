Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZDNS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZDNS3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZDNS2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:28:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39919 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758426AbZDNS17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:59 -0400
Subject: [BUILD FAILURE 04/04] Next April 14 : x86_64 randconfig
	[drivers/media/video/cx231xx/cx231xx-alsa.ko]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-media@vger.kernel.org
Content-Type: text/plain
Organization: IBM
Date: Tue, 14 Apr 2009 23:57:49 +0530
Message-Id: <1239733669.5344.72.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed the following build error:
---
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 578 modules
ERROR:
"snd_pcm_period_elapsed" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_card_create" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR:
"snd_pcm_hw_constraint_integer" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR:
"snd_pcm_link_rwlock" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_pcm_set_ops" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_card_free" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_card_register" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
ERROR: "snd_pcm_new" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
---

Regards--
Subrata


