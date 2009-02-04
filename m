Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZBDALS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZBDALS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZBDALF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:11:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZBDALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:11:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: WARNING: at drivers/pci/pci-driver.c:368
Date: Wed, 4 Feb 2009 01:10:20 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902032315.27113.rjw@sisk.pl> <alpine.DEB.2.00.0902031821590.7302@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.0902031821590.7302@parag-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040110.21455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Parag Warudkar wrote:
> 
> Today's git triggers the below warning on suspending my laptop, which is -
> 
> if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> 
> Would it be helpful to also print info about the device that was not in 
> PCI_D0?

Yes, the patch for that is on its way to Jesse.

BTW, may I ask what about the last patch I sent to you? :-)

Rafael
