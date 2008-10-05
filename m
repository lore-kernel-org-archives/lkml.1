Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYJEUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYJEUQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 16:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYJEUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 16:16:25 -0400
Received: from bu3sch.de ([62.75.166.246]:43440 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYJEUQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:16:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] logging of long delays at boot
Date: Sun, 5 Oct 2008 22:15:54 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810052215.54458.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote some crappy patch to log all long delays and sleeps
during the boot process. It shows quite a few interesting
calls to huge delays on my powerbook (where the kernel takes
about 10 seconds to boot).

Well, I just post this here in case somebody is interested in it.
This is _not_ a submission for merging with the mainline kernel.

The patch currently is prepared for powerpc only. Other architectures
might need some adjustments in the arch code (some archs override msleep
and stuff...)

Have fun.

http://bu3sch.de/patches/wireless-testing/20081005-2206/patches/delay-logging.patch

-- 
Greetings Michael.
