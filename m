Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXLMJOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXLMJOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXLMJOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:14:35 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:32960 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbXLMJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:14:34 -0500
Date: Thu, 13 Dec 2007 12:14:35 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071213121435.C21124@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no> <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no> <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca> <1197523602.15741.114.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1197523602.15741.114.camel@pasglop>; from benh@kernel.crashing.org on Thu, Dec 13, 2007 at 04:26:42PM +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 04:26:42PM +1100, Benjamin Herrenschmidt wrote:
> I can try to whip up some code tomorrow I suppose, though I'm always
> afraid some dodgy x86 setup will blow up...

That scares me too, but something like pci_dangling_bar(dev, idx) with
a default (for now) no-op implementation in asm-generic/pci.h should
be safe...

Ivan.
