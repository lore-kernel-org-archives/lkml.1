Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZEKNmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZEKNmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZEKNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:41:33 -0400
Received: from mx1.emlix.com ([193.175.82.87]:33071 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZEKNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:41:32 -0400
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: xtensa patches for -rc5
Date: Mon, 11 May 2009 15:43:32 +0200
Message-Id: <1242049417-12564-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

due to SPI and net driver not getting into .30, I was able to drop all
the controversial patches affecting xtensa IRQ code.  Also the DMA
engine support is now not pressing anymore.

What's left is pretty trivial.  Two fixes, one affecting stack trace
printing for generic xtensa.  Both bugs were introduced with this
merge window so it would be good to have the fixes in before the
release.

The other part is the boot-time clock calibration on s6000.

Please consider merging this before .30 gets released.  We can take
care about the rest for .31.

Thanks,

	Hannes
