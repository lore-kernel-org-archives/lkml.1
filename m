Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXL0POS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXL0POS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 10:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXL0POH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 10:14:07 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:44171 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXL0POG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:14:06 -0500
Date: Thu, 27 Dec 2007 16:14:04 +0100
Message-Id: <71066803@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: broken modules - hgafb and physmap !?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19Fupwe2SQPg2Jh3Sp/H8/yn54fKCj6UzPthGFP9nOqV1srB
 BSsYeipu/eUiRXIo1IpevLdfh7bx/VhKL5kLUleTSBS6FHAvIo=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i did some module tests with 2.6.24-rc  kernel (suse) and think i found some issues with modules.
for some of those i found i`m not yet sure if they are mainline issues, but the following should exist in mainline too (see below)

i searched this list and also bugzilla and found no reference there, so maybe it`s worth posting it here.

anyway, these are probably minor/cosmetic.


modprobe hgafb; rmmod hgafb
modprobe physmap;rmmod physmap

hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
Device 'hgafb.0' does not have a release() function, it is broken and must be fixed.
WARNING: at drivers/base/core.c:107 device_release()
 [<c01ccd15>] kobject_cleanup+0x3d/0x54
 [<c01ccd2c>] kobject_release+0x0/0x8
 [<c01cd8d4>] kref_put+0x60/0x6d
 [<c023fb77>] platform_device_del+0x12/0x37
 [<e0a7c4f2>] hgafb_exit+0xa/0x14 [hgafb]
 [<c014170c>] sys_delete_module+0x190/0x1c0
 [<c0161176>] remove_vma+0x36/0x3b
 [<c0104e22>] sysenter_past_esp+0x6b/0xa9
 =======================
physmap platform flash device: 04000000 at 08000000
physmap-flash physmap-flash.0: Could not reserve memory region
physmap-flash: probe of physmap-flash.0 failed with error -12
Device 'physmap-flash.0' does not have a release() function, it is broken and must be fixed.
WARNING: at drivers/base/core.c:107 device_release()
 [<c01ccd15>] kobject_cleanup+0x3d/0x54
 [<c01ccd2c>] kobject_release+0x0/0x8
 [<c01cd8d4>] kref_put+0x60/0x6d
 [<c023fb90>] platform_device_del+0x2b/0x37
 [<e0aa42ca>] physmap_exit+0xa/0x14 [physmap]
 [<c014170c>] sys_delete_module+0x190/0x1c0
 [<c0161176>] remove_vma+0x36/0x3b
 [<c0104e22>] sysenter_past_esp+0x6b/0xa9
 =======================

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

