Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXLKQmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXLKQmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbXLKQmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:42:00 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35819 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXLKQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:41:59 -0500
Message-ID: <475EBD69.9090709@keyaccess.nl>
Date: Tue, 11 Dec 2007 17:40:09 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Paul Rolland <rol@as2917.net>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl> <18270.48009.256443.854729@stoffel.org>
In-Reply-To: <18270.48009.256443.854729@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 17:32, John Stoffel wrote:

> Here's my results on a PIII Xeon, 550mhz, 440GX chipset, and an ISA
> slot, which until recently was actually used with an 8 port serial
> card:
> 
> jfsnew:~/src> sudo ./port80
> out: 729
> in : 348
> jfsnew:~/src> sudo ./port80
> out: 729
> in : 354
> jfsnew:~/src> sudo ./port80
> out: 729
> in : 350
> jfsnew:~/src> sudo ./port80
> out: 728
> in : 346
> jfsnew:~/src> sudo ./port80
> out: 730
> in : 340

Thank you. That's a little odd. The "in" time should be close to the "out" 
time really.

Well, err, <shrug> I guess.

For now noone's contemplating replacing the out with an in anyways :-)

Rene.

