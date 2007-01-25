Return-Path: <linux-kernel-owner+w=401wt.eu-S965517AbXAYPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517AbXAYPfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965516AbXAYPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:35:41 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40118 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482AbXAYPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:35:40 -0500
Date: Thu, 25 Jan 2007 10:35:10 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Seetharam Dharmosoth <seetharam_kernel@yahoo.co.in>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: que: How can we Eliminate the DMA Zone from the kernel?
Message-ID: <20070125153510.GA13938@athena.road.mcmartin.ca>
References: <161367.39134.qm@web7706.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161367.39134.qm@web7706.mail.in.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 12:56:30PM +0000, Seetharam Dharmosoth wrote:
> Hi,
> 
> Want to remove DMA zone the from the Linux Kernel.
> (Don't want to use DMA Zone, because i am not
> using ISA bus, am using PCI bus. So, I don't need
> this)
> 

Just because you don't need ISA, doesn't mean you don't need
ZONE_DMA. Various PCI cards have limitations on what addresses they
can DMA to (24 bits on some old PCI sound cards iirc, and more recently
a 30 bit DMA limitation on some Broadcom networking equipment.)
