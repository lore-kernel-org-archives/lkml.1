Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYIZJIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYIZJIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYIZJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:08:01 -0400
Received: from rayleigh.systella.fr ([213.41.184.253]:52924 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYIZJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:08:00 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 05:08:00 EDT
From: BERTRAND Joel <bertrand@rayleigh.systella.fr>
Message-Id: <200809260859.m8Q8xp0r008656@rayleigh.systella.fr>
To: linux-kernel@vger.kernel.org
Subject: Fwd: 2.6.26.x hangs on amd64/smp
Reply-To: wilhelm-siegfried.knatschke-koenigsberg@chezmoi.com
Date: Fri, 26 Sep 2008 10:59:50 +0200
User-Agent: slrn/pre0.9.9-111 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [127.0.0.1]); Fri, 26 Sep 2008 10:59:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: BERTRAND Joel <joel.bertrand@systella.fr>
Newsgroups: linux.kernel
Subject: 2.6.26.x hangs on amd64/smp
Reply-To: mt1@systella.fr

	Some news.

	I have done some tests with the _same_ configuration, but without
	resident X (and console on a serial line). I'm not able to reproduce
	this bug anymore even with a load average
	greater than 30 (memory usage : 4GB + 6GB swap). Thus, this trouble
	seems to be X related.

	Graphic card is :
01:00.0 VGA compatible controller: ATI Technologies Inc M76 [Radeon
Mobility HD 2600 Series]

	Xorg configuration :
Section "Device"
    Identifier  "ATI Technologies Inc ATI Default Card"
	Driver      "radeonhd"
#   Driver      "fglrx"
	BusID       "PCI:1:0:0"
EndSection

cauchy:[~] > dpkg-query -l | grep xorg
ii  xorg                                                    1:7.3+16
...
ii  xserver-xorg-video-radeonhd                             1.2.1-2             

	I'm writing a bug report on Xorg website.

	Regards,

	JKB

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
