Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXKKRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXKKRC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 12:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXKKRCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 12:02:19 -0500
Received: from neopsis.com ([213.239.204.14]:57825 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757217AbXKKRCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 12:02:18 -0500
X-Greylist: delayed 1161 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 12:02:18 EST
Message-ID: <473730F6.2010900@dbservice.com>
Date: Sun, 11 Nov 2007 17:42:30 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: laptop reboots right after hibernation
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.283,
	required 5, autolearn=spam, AWL 0.22, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

echo disk > /sys/power/state

successfully saves that state to the disk, but just as the laptop is
about to turn itself off, it reboots (successfully, so the
hibernation/resume process works well, even with X running! which is
awesome :) ). But I'd rather like the computer turned off after I
hibernate it. Where could the problem be?

It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
days, both suspend and hibernate worked there (with one or two crashes,
probably due to X, I've read that the intel driver got some
suspend/resume improvements recently). Now I'm running gentoo, kernel
2.6.24-rc2. I'm using newer versions of almost all software now compared
to the ubuntu system.

tom
