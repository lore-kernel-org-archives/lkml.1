Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbXJLVXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbXJLVXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbXJLVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:22:48 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:57471 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181AbXJLVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:22:47 -0400
Message-ID: <470FE5A0.8000009@lwfinger.net>
Date: Fri, 12 Oct 2007 16:22:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: ppisa@pikron.com
Subject: Build error for 2.6.23-git1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.23-git1, if "MMC/SD card support" is selected, and LED driver support is not selected in the
configuration, the following build errors occur:

drivers/mmc/core/host.c: In function ‘mmc_remove_host’:
drivers/mmc/core/host.c:146: error: implicit declaration of function ‘led_trigger_unregister’
drivers/mmc/core/host.c:146: error: ‘struct mmc_host’ has no member named ‘led’

My architecture is x86_64, but I don't think that makes a difference.

Larry
