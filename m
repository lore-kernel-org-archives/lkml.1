Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbXHPUvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbXHPUvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXHPUvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:51:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3183 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbXHPUvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:51:38 -0400
Subject: RFHelp:  Splitting MAINTAINERS into maintainers/* and
	Makefile/Kconfig support
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Aug 2007 13:51:36 -0700
Message-Id: <1187297496.5906.113.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a tree with a directory full of separate
MAINTAINER blocks that looks like:

00_file_description
3c359_network_driver
3c505_network_driver
3c59x_network_driver
3cr990_network_driver
...
zd1211rw_wireless_driver
zf_machz_watchdog
zr36067_video_for_linux_driver
zs_decstation_z85c30_serial_driver
zz_the_rest

A little more than 600 files

So that distributions could continue to produce
a MAINTAINERS block if desired, how could
make be extended to produce such a file from
these individual blocks?

Maybe:
        "cat [0-9a-z]* > ../MAINTAINERS"?

Would it need to?

Anyone have suggestions for Makefile/Kconfig support?


