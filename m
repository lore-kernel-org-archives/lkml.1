Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZHAPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZHAPwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZHAPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:52:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58817 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZHAPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:52:18 -0400
Date: Sat, 1 Aug 2009 17:52:18 +0200
From: Andreas Mohr <andi@lisas.de>
To: Jack Byer <ojbyer@usa.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
Message-ID: <20090801155218.GA8921@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h51hro$p6j$1@ger.gmane.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Is this expected behavior? Is there any setup I am missing that would make this faster?

No, certainly not, I don't remember it to be this slow (it's been a
while since I last tried though, still have hardware here).
Possibly it's a DMA misdetection problem (keeps trying to use DMA
despite it not being possible) which is common with CF type setups.
Try fiddling with hdparm or blktool DMA-related or I/O setup settings.
Other things would include libata.dma=0 (or other values!) for libata
layer or ide-core.nodma= boot parameter (for IDE layer).

And if this indeed is the problem, then it would be very useful to
get automatic handling implemented properly.

Andreas Mohr
