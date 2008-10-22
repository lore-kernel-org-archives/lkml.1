Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbYJVTap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbYJVTap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYJVTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:30:08 -0400
Received: from heinz.dinsnail.net ([87.106.63.74]:42143 "EHLO
	heinz.dinsnail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbYJVTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:30:06 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 15:30:06 EDT
Date: Wed, 22 Oct 2008 21:16:51 +0200
From: Michael Weiser <michael@weiser.dinsnail.net>
To: linux-kernel@vger.kernel.org
Subject: rtc/i2c-mpc stops working with 2.6.27 on Linkstation HG (powerpc)
Message-ID: <20081022191650.GA11406@weiser.dinsnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-dinsnail.net-MailScanner-ID: m9MJK60C028810
X-MailScanner: Found to be clean
X-MailScanner-From: michael@weiser.dinsnail.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with 2.6.27(-gentoo) the rtc (Ricoh 5c372) is no longer found on my
Linkstation HG. It seems, the i2c-mpc driver doesn't even find the I2C
controller.

Could this be related to commit
#0d1cde235874b00905bce23f659690d060ebf475 (powerpc/i2c: Convert i2c-mpc
into an of_platform driver,
http://kerneltrap.org/mailarchive/git-commits-head/2008/7/16/2522594/thread)?

What do I need to do, to make it work again?

The configs are virtually identical. The kernels are loaded with their
respective dtb files. The dtb and dts files are identical anyways.
-- 
Thanks,
Micha
