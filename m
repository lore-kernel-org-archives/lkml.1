Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbXJ3TOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbXJ3TOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXJ3TNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:13:54 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:34167 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbXJ3TNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:13:53 -0400
Date: Tue, 30 Oct 2007 20:13:17 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Per Liden <per.liden@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>
Subject: tipc_config.h requires linux/string.h, which does not exist in
	exported headers
Message-ID: <20071030191317.GB9403@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Per Liden <per.liden@ericsson.com>,
	Allan Stephens <allan.stephens@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CculzwpJEsD8s=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for random Cc: list.

v2.6.24-rc1-423-g97855b4, with CONFIG_HEADERS_CHECK=y

$ make
...
  CHECK   include/linux/tipc_config.h
/home/raa/linux/usr/include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers
make[3]: *** [/home/raa/linux/usr/include/linux/.check.tipc_config.h] Error 1
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2


