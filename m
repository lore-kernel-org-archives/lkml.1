Return-Path: <linux-kernel-owner+w=401wt.eu-S1030530AbXAYTiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030530AbXAYTiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXAYTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:38:21 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:14419 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030527AbXAYTiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:38:19 -0500
Date: Thu, 25 Jan 2007 11:33:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Seetharam Dharmosoth <seetharam_kernel@yahoo.co.in>,
       linux-kernel@vger.kernel.org
Subject: Re: que: How can we Eliminate the DMA Zone from the kernel?
Message-Id: <20070125113312.830bbada.randy.dunlap@oracle.com>
In-Reply-To: <20070125153510.GA13938@athena.road.mcmartin.ca>
References: <161367.39134.qm@web7706.mail.in.yahoo.com>
	<20070125153510.GA13938@athena.road.mcmartin.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 10:35:10 -0500 Kyle McMartin wrote:

> On Thu, Jan 25, 2007 at 12:56:30PM +0000, Seetharam Dharmosoth wrote:
> > Hi,
> > 
> > Want to remove DMA zone the from the Linux Kernel.
> > (Don't want to use DMA Zone, because i am not
> > using ISA bus, am using PCI bus. So, I don't need
> > this)
> > 
> 
> Just because you don't need ISA, doesn't mean you don't need
> ZONE_DMA. Various PCI cards have limitations on what addresses they
> can DMA to (24 bits on some old PCI sound cards iirc, and more recently
> a 30 bit DMA limitation on some Broadcom networking equipment.)

If your platform really doesn't need ZONE_DMA, then you should
look at lots of discussion and patches on the linux-mm
mailing list.

See http://linux-mm.org/LinuxKernelMailingLists
and emails or patches from Christoph Lameter, Andi Kleen,
and Marcelo Tosatti.

---
~Randy
