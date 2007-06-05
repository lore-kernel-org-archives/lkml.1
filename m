Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbXFEJ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbXFEJ5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763735AbXFEJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:57:00 -0400
Received: from mail.belkam.com ([213.24.1.51]:50295 "EHLO mail.belkam.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763744AbXFEJ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:56:59 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 05:56:57 EDT
Message-ID: <46652EB3.4060903@belkam.com>
Date: Tue, 05 Jun 2007 14:36:51 +0500
From: Dmitry Melekhov <dm@belkam.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: scsi lun online resize
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm playing with iscsi on linux.
And I have following problem:

If I change lun size on target side and then do echo "1" >/sys/block/
sdb/device/rescan
device size is changed only if /dev/sdb is not mounted, if it is
mounted fdisk shows no size change, so lun can't be resized online.

open-iscsi guys say this is general linux problem, not iscsi specific.
Could you tell me is there any solution?

Thank you!

