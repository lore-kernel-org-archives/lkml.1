Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXLKRGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXLKRGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXLKRGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:06:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbXLKRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:06:13 -0500
Message-ID: <475EC342.8080901@zytor.com>
Date: Tue, 11 Dec 2007 09:05:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       David Newall <david@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com>
In-Reply-To: <475EC1C0.2040000@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS - 
> other ports have been used in the history of the IBM PC family by some 
> vendors, and some machines have used it for DMA port mapping!!

Correction: ALL machines use it for DMA port mapping.  The port is 
assigned to the legacy DMA controller, but performs no operation. 
That's what makes it safe to write (NOT read!)

	-hpa
