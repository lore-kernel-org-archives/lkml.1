Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXLMVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXLMVC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763523AbXLMVCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:02:18 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:51645 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759911AbXLMVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:02:17 -0500
Date: Fri, 14 Dec 2007 00:02:25 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071214000225.A21652@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no> <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no> <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca> <20071213120403.B21124@jurassic.park.msu.ru> <20071213102424.18b621a7@the-village.bc.nu> <1197544621.15741.132.camel@pasglop> <1197544820.15741.137.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1197544820.15741.137.camel@pasglop>; from benh@kernel.crashing.org on Thu, Dec 13, 2007 at 10:20:20PM +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 10:20:20PM +1100, Benjamin Herrenschmidt wrote:
> I may have not fully undestood you in my previous reply. You are proposing
> replacing pci_enable_device_bars() with a pair of pci_enable_device_io/mem ?
> 
> I think that would be a good idea indeed.

I'm all for it. Never liked pci_enable_device_bars :-)

Ivan.
