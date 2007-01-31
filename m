Return-Path: <linux-kernel-owner+w=401wt.eu-S1030191AbXAaXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191AbXAaXMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030214AbXAaXMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:12:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49183 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030191AbXAaXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:12:15 -0500
Date: Wed, 31 Jan 2007 23:24:25 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
Message-ID: <20070131232425.5e767d0b@localhost.localdomain>
In-Reply-To: <45C0FE30.4000800@ru.mvista.com>
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>
	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>
	<45B4FFBD.40507@ru.mvista.com>
	<20070122184620.1c8b87ac@localhost.localdomain>
	<45C0FE30.4000800@ru.mvista.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> should be slightly overclocking PIO modes 0/1 (ULi docs don't shed much light 
> on how it should be calculated)... Well, this seems fixed in libata drivers.

The libata code for tuning is based upon the BIOS programmers guide. That
seemed to be the best coverage of a minimal selection. It's also got a
big "confidential" stamp on it so I can't pass it on.

Alan
