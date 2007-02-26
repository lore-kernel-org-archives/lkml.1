Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXBZQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXBZQFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXBZQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:05:05 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:41431 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXBZQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:05:03 -0500
Date: Mon, 26 Feb 2007 11:04:50 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioread32 endianess.
Message-ID: <20070226160450.GB3787@athena.road.mcmartin.ca>
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 06:36:05PM +0300, Alexey Zaytsev wrote:
> Hello.
> 
> May I ask you, guys, if ioread32 and his friends should treat the data
> as host-endian or bus-endian? E.g, should the data read from PCI on a
> big-endian host be byte swapped or not?
>

It should be in bus-endian. This is why ioreadXbe() exist.

Cheers,
	Kyle
