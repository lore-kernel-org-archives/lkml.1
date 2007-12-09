Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbXLIFGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbXLIFGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXLIFFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:05:52 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60956 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXLIFFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:05:51 -0500
Message-ID: <475B7763.5000008@keyaccess.nl>
Date: Sun, 09 Dec 2007 06:04:35 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <475AEF8E.5040906@reed.com>
In-Reply-To: <475AEF8E.5040906@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-12-07 20:25, David P. Reed wrote:

> In any case, my machine does not have an ISA bus.  Why should it?  It's 
> a laptop!

A bus is not something with expansion slots. Your machine has an ISA bus, or 
LPC rather, if only to hang its BIOS of. That earlier report about BIOS 
chips shitting themselves due to aborts on LPC together with ACPI involving 
the BIOS sounds a bit suspicious (and in that case using 0xed shouldn't help 
any).

Rene.
