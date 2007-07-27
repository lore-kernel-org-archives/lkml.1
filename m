Return-Path: <linux-kernel-owner+w=401wt.eu-S934749AbXG0Fuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbXG0Fuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 01:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbXG0Fu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 01:50:28 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:3847 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXG0Fu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 01:50:27 -0400
Date: Fri, 27 Jul 2007 07:50:26 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: Investigating SD card failures
Message-ID: <20070727055026.GB27423@roarinelk.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I have a 1GB SanDisk SD card here which linux does not recognize.
Looking at the MMC debug output, I see the MMC core repeatedly
issues CMD55/CMD41 commands (which all succeed!) then stops
after 100 times.  In sd_ops.c the code checks for a bit to get set.
My question is, what exactly is this bit supposed to indicate?

Thanks,
	Manuel Lauss
