Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXLQRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXLQRCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXLQRCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:02:37 -0500
Received: from outbound-mail-47.bluehost.com ([69.89.18.16]:54147 "HELO
	outbound-mail-47.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583AbXLQRCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:02:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 12:02:35 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend, sometimes (drm related) [Was: 2.6.24-rc5-mm1]
Date: Mon, 17 Dec 2007 08:55:43 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <47646A6C.7070007@gmail.com>
In-Reply-To: <47646A6C.7070007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712170855.43556.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.14.59 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> next suspend/resume try:
> BLE drm_addmap_core a: map ffff81007c2d9b00, handle 0000000000000000
> BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_addmap_core a: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_addmap_core a: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_addmap_core c: map ffff81007c2d9b00, handle ffffc20010092000
> BLE drm_addmap_core a: map ffff81007c2d90c0, handle 8000000000000000
> BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007c2d90c0, handle 0000000000000000
> BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007c2d9800, handle 0000000000000000
> BLE drm_addmap_core b: map ffff81007c2d9800, handle ffffc20010380000
> BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007c2d9e80, handle ffff81007c2d9d40
> BLE drm_addmap_ioctl a: map ffff81007c2d96c0, handle 0000000000000000
> BLE drm_core_ioremap: map ffff81007d0ab050, handle ffffc20010240000
> set status page addr 0x00033000
> BLE drm_core_ioremap: map ffff81007d0ab098, handle ffffc20010096000
> BLE drm_addmap_core a: map ffff81007bd7d440, handle 6632785c63766632
> BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007bd7d700, handle 6632785c63766632
> BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007c16f840, handle ffff81007c16f680
> BLE drm_addmap_ioctl a: map ffff81007bd7d080, handle 0000000000000000
> BLE drm_addmap_core a: map ffff81007c16f2c0, handle ffff81007cc33e10
> BLE drm_addmap_ioctl a: map ffff81007c16f640, handle 0000000000000000
> BLE drm_core_ioremapfree a: map ffff81007d0ab050, handle ffffc20010240000
> BLE drm_core_ioremapfree b: map ffff81007d0ab050, handle ffffc20010240000
> BLE drm_core_ioremapfree a: map ffff81007d0ab098, handle ffffc20010096000
> BLE drm_core_ioremapfree b: map ffff81007d0ab098, handle ffffc20010096000
> BLE drm_rmmap_locked a: map ffff81007c2d9800, handle ffffc20010380000
> BLE drm_rmmap_locked b: map ffff81007c2d9b00, handle ffffc20010092000
> PM: Syncing filesystems ... done.
> PM: Preparing system for mem sleep
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Entering mem sleep
> sd 2:0:0:0: [sdc] Synchronizing SCSI cache
> sd 2:0:0:0: [sdc] Stopping disk
> sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> sd 1:0:0:0: [sdb] Stopping disk
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> drm_sysfs_suspend
> BAD BAD BAD ffff81007c2d9800 0000000000000000
> suspend_device(): drm_sysfs_suspend+0x0/0x40() returns -5
> Could not suspend device card0: error -5
> sd 0:0:0:0: [sda] Starting disk
>
> I;m out of ideas, please give me a clue.

This sounds a lot like a problem we had recently.  The driver wasn't 
preserving its mappings across X startup/shutdown (drm open/close) and so 
you'd see crashes like this.  It should be fixed already in DRM git.

Jesse
