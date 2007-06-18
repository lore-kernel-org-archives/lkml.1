Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbXFRGo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbXFRGo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbXFRGoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:44:10 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17769 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbXFRGoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:44:09 -0400
Date: Mon, 18 Jun 2007 08:43:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: dave young <hidave.darkstar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cdrom_sysctl_info fix
Message-ID: <20070618064350.GQ6149@kernel.dk>
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com> <20070615132657.GW6149@kernel.dk> <20070618125811.GA1692@darkstar.te-china.tietoenator.com> <20070618062722.GP6149@kernel.dk> <a8e1da0706172341j3ee621efs8b2809b4fd094004@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0706172341j3ee621efs8b2809b4fd094004@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18 2007, dave young wrote:
> Hi,
> >Yep that looks much better! I trust you booted and tested this and the
> >output looks correct?
> Yes, I tested and the output is correct.

Good

> BTW, another problem, I can't find the CONFIG_CDROM option in kernel
> config menu. Is it deperacated? If it is true, is the module part
> still necessary?

cdrom.o is a hardware independent helper module, it gets included if you
use atapi/scsi/etc cdrom drivers. See drivers/cdrom/Makefile.

-- 
Jens Axboe

