Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbXLLNOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbXLLNOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXLLNNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:13:54 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4572 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLLNNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:13:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 12 Dec 2007 13:12:20.0734 (UTC) FILETIME=[A0B011E0:01C83CC0]
Content-class: urn:content-classes:message
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Date: Wed, 12 Dec 2007 08:11:59 -0500
Message-ID: <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com>
in-reply-to: <475F23BD.3040903@reed.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
thread-index: Acg8wKC+pnCAXdu4Ru2oF8dhWZGEgw==
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl> <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com> <475F23BD.3040903@reed.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "David P. Reed" <dpreed@reed.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Paul Rolland" <rol@as2917.net>, "David Newall" <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, <rol@witbe.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Dec 2007, David P. Reed wrote:

> 1) I found in a book, the Undocumented PC, that I have lying around that
> the "pause" recommended for some old adapter chips on the ISA bus was 1
> usec.  The book carefully points out on various models of PCs how many
> short jumps are required to implement 1 usec, and suggests that for
> faster machines, 1 usec loops be calibrated.  That seems like a good
> heuristic.
>
> 2) Also, Dick, you got me interested in doing more historical research
> into electrical specs and circuit diagrams (which did come with the IBM
> 5150).  The bus in the original IBM PC had no problem with "bus capacity
> being charged" as you put it.   Perhaps you don't remember that the I/O
> bus had the same electrical characteristics as the memory bus.  Thus
> there is no issue with the bus being "charged".  The issue of delays
> between i/o instructions was entirely a problem of whether the adapter
> card could clock data into its buffers and handle the clocked in data in
> time for another bus cycle.  This had nothing to do with "charging" -
> buses in those days happily handled edges that were much faster than 1 usec.

Wrong: the bus is not a clocked bus. Read a book. There is
a "clock" trace provided, but it has nothing to do with the
bus or its timing. The bus is not impedance-controlled, nor
is it clocked. It relies upon certain established states.
Look in the back of the IBM/PC book or read about the bus
in http://www.techfest.com/hardware/nis/isa.htm and observe
the bus-timing with no clock involved at all.

>
> We at Software Arts did what we did based on direct measurements and
> testing.  We found that the early BIOS listings were usually fine, but
> in fact were misleading. After all, the guys who built the machine and
> wrote the BIOS were in a hurry.  There were errata.
>

Yep. We are all wrong. You come out of nowhere and claim to
be right. Goodbye.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
