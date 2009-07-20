Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZGTPPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZGTPPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZGTPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:15:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38143 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbZGTPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:15:23 -0400
Date: Mon, 20 Jul 2009 16:16:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas =?ISO-8859-14?B?SGVsbHN0cvZt?= <thomas@shipmail.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
 Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720161620.7b027f8d@lxorguk.ukuu.org.uk>
In-Reply-To: <4A648718.9000709@shipmail.org>
References: <4A647358.1040009@shipmail.org>
	<20090720135844.GA16844@infradead.org>
	<4A648718.9000709@shipmail.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the common agreement of the linux community is to *NOT* allow these 
> drivers in, so be it, then be honest and go ahead and tell the driver 
> writers. Don't make them respin their development trying to fix minor 
> flaws when their driver won't get in anyway!

The existing policy based on what has been rejected is:

- If you have something which only works with some non-free tightly
  integrated software then we don't accept it

	Examples - GMX500, Intel wireless regulatory daemon.


So until there is an open source user and test case for the kernel code
it has no place in the kernel (and indeed if the two are closely
interconnected and dependent then there are good 'talk to your lawyer'
reasons as well)

Once there is a useful combination of kernel/user space free software for
the card then it makes sense to look at a merge. Until then you don't
even know what the final interface will look like and what is actually
needed kernel side.

The VIA stuff might be a useful basis for that work but that is a when/if
anyone ever writes drivers for it.

My guess is that if someone cares enough about the hardware they need to
get EXA working along with 2D render, then submit the bits the need to do
hardware rendering. After that tackle what is needed for 3D - as is
happening with the Nvidia drivers and then submit a DRM module for their
work.

Alan
