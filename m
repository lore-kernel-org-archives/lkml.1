Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbXLIQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbXLIQ7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXLIQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 11:59:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXLIQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:59:11 -0500
Date: Sun, 9 Dec 2007 17:59:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071209165908.GA15910@one.firstfloor.org>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209125458.GB4381@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I mean, we expect 8usec delay -- historical ISA timing -- but when
> _PCI_ card with leds is inserted, it is likely to be faster than old
> ISA, right?

Yes, i guess switching to udelay at least on newer systems would
be a good idea.  I'm not quite sure about systems without TSC though.

-Andi
