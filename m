Return-Path: <linux-kernel-owner+w=401wt.eu-S965963AbXCPVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963AbXCPVVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965962AbXCPVVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:21:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36474 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965959AbXCPVVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:21:50 -0400
Date: Fri, 16 Mar 2007 14:21:31 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       michal.k.k.piotrowski@gmail.com, linux-ide@vger.kernel.org,
       tglx@linutronix.de, mlord@pobox.com, linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
Message-ID: <20070316142131.0a4cc953@freekitty>
In-Reply-To: <45F8B160.6010603@gmail.com>
References: <20070314152302.GB15600@htj.dyndns.org>
	<20070314100716.5965dca1@freekitty>
	<45F8B160.6010603@gmail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All this discussion is well and good, but I suspect there is a driver setup
problem where the interrupt isn't being handled properly. Please retest with
the latest version of skge driver (I just pushed patches to netdev about 2min ago).
One patch changes to disable IRQ's from device for packets until device
is brought up.

