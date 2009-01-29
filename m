Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZA2Ax0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZA2Ax0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbZA2Aww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:52:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757712AbZA2Awv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:52:51 -0500
Date: Wed, 28 Jan 2009 16:51:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, roel.kluin@gmail.com, mingo@redhat.com,
       magnus.damm@gmail.com, tglx@linutronix.de
Subject: Re: [PATCH 000/011] early platform patches
Message-Id: <20090128165150.09a60673.akpm@linux-foundation.org>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 19:57:21 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> early platform patches
> 
> [PATCH 001/011] early platform driver V3
> [PATCH 002/011] sh: add plat_early_device_setup() function
> [PATCH 003/011] sh: plat_early_device_setup() for sh2
> [PATCH 004/011] sh: plat_early_device_setup() for sh2a
> [PATCH 005/011] sh: plat_early_device_setup() for sh3
> [PATCH 006/011] sh: plat_early_device_setup() for sh4
> [PATCH 007/011] sh: plat_early_device_setup() for sh4a
> [PATCH 008/011] sh: add early platform support for earlyprintk
> [PATCH 009/011] sh-sci: add early platform support
> [PATCH 010/011] sh: add early platform support for earlytimer
> [PATCH 011/011] sh_cmt: add early platform support
> 
> These patches add early platform driver support to the serial port
> driver and the CMT timer driver on the SuperH architecture.
> 
> The following patch sets posted to linuxsh-dev are required:
> 
> - [PATCH 000/013] sh-sci: platform device, clock and console changes
> - [PATCH 00/05] sh: timer patches

Oh, that explains all the rejects.

> The early platform driver V3 patch is a replacement for V2 in -mm.
> 

Well, it looks OK to me, but I don't really know what I'm looking at.

David, Kay, Tejun: would you be able to take a look at 001/011
sometime, please?

Thanks
