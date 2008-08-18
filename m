Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbYHRTL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbYHRTL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbYHRTGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:06:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59268 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758559AbYHRTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:06:35 -0400
Date: Mon, 18 Aug 2008 19:49:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Matt_Domsch@dell.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long
 Physical Sectors
Message-ID: <20080818194910.6c269626@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818184246.GH677@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	<1217957207-23116-3-git-send-email-matthew@wil.cx>
	<48A8B211.8030103@pobox.com>
	<20080818181523.GG677@parisc-linux.org>
	<20080818190629.22fd618c@lxorguk.ukuu.org.uk>
	<20080818184246.GH677@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do we need to do that?  Leaving sector_size_supported() unset means
> exactly "no to anything but 512".  I'll be quite surprised if we see
> PATA drives supporting 4096 or 520 byte sectors anyway.  It seems like
> a premium feature.

Good point on the former - yes it defaults sane now so that doesn't need
doing. For the sector size remember a lot of PATA chips appear with SATA
bridges at times - especially promise and highpoint.
