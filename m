Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYJOHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYJOHDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYJOHDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:03:00 -0400
Received: from webmail58.yandex.ru ([77.88.61.3]:36248 "EHLO
	webmail58.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYJOHDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:03:00 -0400
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 03:03:00 EDT
X-Yandex-Spam: 1
From: Antipov Dmitry <dmantipov@yandex.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
MIME-Version: 1.0
Message-Id: <414861224052797@webmail58.yandex.ru>
Date: Wed, 15 Oct 2008 10:39:57 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating the kernel to 2.6.27 from 2.6.25.4, my system time goes wrong and
CPU becomes 0 MHz (as shown by /proc/cpuinfo), probably due to these issues:

TSC: Unable to calibrate against PIT
TSC: No reference (HPET/PMTIMER) available
Marking TSC unstable due to could not calculate TSC khz

The hardware is http://www.fit-pc.com/new/fit-pc-1-0-specifications.html,
and the base system is Fedora 9.

More details: 2.6.25.4 .config: http://78.153.153.8/tmp/config-2.6.25.4.txt
              2.6.25.4 boot messages: http://78.153.153.8/tmp/boot-2.6.25.4.txt
              2.6.27 .config: http://78.153.153.8/tmp/config-2.6.27.txt
              2.6.27 boot messages: http://78.153.153.8/tmp/boot-2.6.27.txt

Dmitry
