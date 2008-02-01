Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYBAJrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYBAJrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYBAJrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:47:40 -0500
Received: from greensrv.RZ.UniBw-Muenchen.de ([137.193.10.35]:59414 "EHLO
	GreenSrv.rz.unibw-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYBAJrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:47:39 -0500
X-Remarks: If SPAM is relayed via GreenSrv.rz.unibw-muenchen.de to outside of unibw-muenchen.de, please report it to abuse@unibw-muenchen.de
Message-ID: <47A2EAAF.90600@pc0312b.rz.unibw-muenchen.de>
Date: Fri, 01 Feb 2008 10:47:27 +0100
From: Claude Frantz <claude@pc0312b.rz.unibw-muenchen.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: permission denied while load kernel module using modprobe
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

As user "root" I'm trying to load the ath_pci module from madwifi using
the "modprobe" command, which is the recommanded way. But I get the
following diag in the log:

modprobe: WARNING: Could not open '/lib/modules/2.6.23.8-34.fc7/net/ath_hal.ko': Permission denied 
modprobe: WARNING: Could not open '/lib/modules/2.6.23.8-34.fc7/net/wlan.ko': Permission denied 
modprobe: FATAL: Could not open '/lib/modules/2.6.23.8-34.fc7/net/ath_rate_sample.ko': Permission denied 
kernel: Error loading module "ath_rate_sample"


Fedora 7 using kernel 2.6.23.8-34.fc7 as you can see above.
All components in /lib/modules/2.6.23.8-34.fc7/net/ have the permission -rwxr-xr-x 
and the directory itself has drwxr-xr-x 

Which permission is wrong here ?

Thanks a lot !

Claude
