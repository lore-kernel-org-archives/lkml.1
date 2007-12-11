Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXLKG4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXLKG4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLKG4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:56:09 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:50647 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXLKG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:56:08 -0500
Message-ID: <475E341F.9000107@keyaccess.nl>
Date: Tue, 11 Dec 2007 07:54:23 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: David Newall <david@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com>
In-Reply-To: <475DE6F4.80702@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 02:25, H. Peter Anvin wrote:

> David Newall wrote:
>> Where did the 8us delay come from?  The documentation and source is 
>> careful not to say how long the delay is.  Would changing it to, say 
>> 1us, be technically wrong?  Is code that requires 8us correct?
> 
> I think a single ISA bus transaction is 1 µs, so two of them back to 
> back should be 2 µs, not 8 µs...

Sigh. And now where do these _two_ transactions come from? (and yes, see 
Alan's folowups, a transaction on a spec bus is 1 us).

Rene.
