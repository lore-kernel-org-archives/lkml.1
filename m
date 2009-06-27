Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZF0RVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZF0RVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZF0RVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:21:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39915 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZF0RVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:21:07 -0400
Date: Sat, 27 Jun 2009 19:21:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <19013.8005.541836.436991@samba.org>
Message-ID: <alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Jun 2009 05:19:33 +1000, tridge@samba.org wrote:
>
>When VFAT_FS_DUALNAMES is disabled we avoid the creation of 8.3
>short filenames for files on VFAT filesystems that require a long
>name. The patch uses a pattern of 11 bytes in the directory entry
>which contains invalid characters such that it cannot be considered
>to be a valid short filename.

Can't we make this a runtime option?
