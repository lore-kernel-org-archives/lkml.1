Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDAEug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDAEug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 00:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXDAEug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 00:50:36 -0400
Received: from raven.upol.cz ([158.194.120.4]:36132 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXDAEuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 00:50:35 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build error due to not including <linux/errno.h>
In-Reply-To: <20070318220148.bc223088.akpm@linux-foundation.org>
References: <20070318125808.GA25840@linux-mips.org> <Pine.LNX.4.44L0.0703182036060.17900-100000@netrider.rowland.org> <20070319004443.GA25164@linux-mips.org> <20070318220148.bc223088.akpm@linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed + slrn/0.9.8.1pl1 (x86_64-pc-linux-gnu-debian)
Date: Sun, 1 Apr 2007 06:58:41 +0200
Message-Id: <E1HXs9J-0001TO-Nx@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH] Fix build error due to not including <linux/errno.h>
> Date: Sun, 18 Mar 2007 22:01:48 -0800
>
> If is a bit of a pain to maintain CONFIG_SYSFS=n.  But then, it's
> realtively easy to fix things when they do break, and sysfs does consume
> rather a lot of memory at runtime.  Hopefully someone out there is finding
> SYSFS=n to be useful for deeply embedded applications.

Actually i've managed to build and run rc5 for five days now. Not so
embedded amd64 laptop.

Kudos and thanks to Ralf.

After splitting kobject from sysfs, as it was commented Tejun Heo in the

[RFD driver-core] Lifetime problems of the current driver model

maybe something lightweight can emerge, without current 'features' and
going-to-be sysfs-v1,v2,v3 thing...
____
