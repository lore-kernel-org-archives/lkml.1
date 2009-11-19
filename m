Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZKSTia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZKSTia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZKSTi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:38:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55227 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754562AbZKSTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:38:28 -0500
Date: Thu, 19 Nov 2009 19:40:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119194008.2c97edcd@lxorguk.ukuu.org.uk>
In-Reply-To: <4B0590A2.9050306@ru.mvista.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911191838.11791.bzolnier@gmail.com>
	<20091119175051.6a91d160@lxorguk.ukuu.org.uk>
	<200911191852.23061.bzolnier@gmail.com>
	<20091119182132.5155f819@lxorguk.ukuu.org.uk>
	<4B0590A2.9050306@ru.mvista.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     I'd suggest to address the delay by another, separate patch to both 
> pata_hpt37x and pata_hpt3x2n drivers, and accept Bart's original patch for 
> bit reversing...

If you can confirm the 371N is fine without switching to I/O cycles then
I agree entirely with that and I'll push the udelay(10) into all three
plus the drivers/ide one unless Bart beats me to it.

Alan

