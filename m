Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZLCQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZLCQ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZLCQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:57:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53332 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754964AbZLCQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:57:46 -0500
Date: Thu, 3 Dec 2009 16:59:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
Message-ID: <20091203165947.13841802@lxorguk.ukuu.org.uk>
In-Reply-To: <4B1771CD.3090409@garzik.org>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<4B1771CD.3090409@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The merge window is upon us, which by strict rules means that anything 
> not already in libata-dev.git#upstream needs to wait until 2.6.34.

Not quite yet - Linus hasn't said "go"

> However, bug fixes and the like should definitely be in 2.6.33. 
> ->init_host is definitely 2.6.34 material.  Some of the other stuff 
> could go either way.

The bits that probably should be delayed a bit more (if any) IMHO are the
32bit enables for hardware that doesn't use 32bit by default on the
drivers/ide stack, and tweaks for obscure old hardware that won't get
much testing.

The sooner it's all upstream the better.

Alan
