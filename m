Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYG0ICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYG0ICe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYG0ICV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 04:02:21 -0400
Received: from www17.your-server.de ([213.133.104.17]:53228 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYG0ICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 04:02:20 -0400
Subject: next-20080725: System hangs while suspending to disk
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain
Date: Sun, 27 Jul 2008 10:02:11 +0200
Message-Id: <1217145731.3053.6.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to get some console output, so i tried "test" instead of
plattform and got an oops in native_cpu_up().

When i do "echo 0 > /sys/devices/system/cpu/cpu1/online" and
"echo 1 > /sys/devices/system/cpu/cpu1/online" again, i get the
same Oops report (as compared to a "test run with state disk")

http://kerneloops.org/guilty.php?guilty=native_cpu_up&version=2.6.26-release&start=1736704&end=1769471&class=oops

What is wrong here?

Greets
thomas


