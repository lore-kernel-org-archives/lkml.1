Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZGJLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZGJLhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 07:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZGJLhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 07:37:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34771 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZGJLhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:37:11 -0400
Message-ID: <52588.192.168.10.89.1247225810.squirrel@dbdmail.itg.ti.com>
Date: Fri, 10 Jul 2009 17:06:50 +0530 (IST)
Subject: [PATCH 0/2] [MTD] [NAND] Add prefetch and dma support for omap2/3  
              NAND      driver
From: "vimal singh" <vimalsingh@ti.com>
To: linux-mtd@lists.infradead.org
Cc: "Tony Lindgren" <tony@atomide.com>, dwmw2@infradead.org,
       dedekind@infradead.org, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: <54851.192.168.10.89.1243946277.squirrel@dbdmail.itg.ti.com>   
    <47286.192.168.10.89.1244108024.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <47286.192.168.10.89.1244108024.squirrel@dbdmail.itg.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have splited gpmc prefetch support for NAND into two patches:
[PATCH 1:2] : Adding support for nand prefetch-read and post-write, in MPU mode.
[PATCH 2:2] : Adding DMA mode support in nand prefetch/post-write

These patches implements Tony's comments. (For comments and discussion see:
http://lists.infradead.org/pipermail/linux-mtd/2009-June/025993.html)

Other than that, gpmc_prefetch_(inti/request) call has been removed, as nothing
great was done in that and we really do not need that.

Function 'gpmc_prefetch_enable' does check for 'if prefetch is already being
used by some other driver?'. And if it is busy, normal cpu copy method for
read/write request will be used.

Thanks and regards,
vimal




