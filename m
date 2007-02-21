Return-Path: <linux-kernel-owner+w=401wt.eu-S1422738AbXBUSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738AbXBUSMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXBUSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:12:17 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3452 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422738AbXBUSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:12:17 -0500
Message-ID: <45DC8B3A.2080301@xs4all.nl>
Date: Wed, 21 Feb 2007 19:11:06 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>	<45DA7643.4020305@xs4all.nl>	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>	<45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain> <45DC5E67.8060101@xs4all.nl>
In-Reply-To: <45DC5E67.8060101@xs4all.nl>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BTW:

Is the situation, with default DN setting of 19 as displayed below,
`normal` w.r.t. interrupts?
I mean: Both the DVB card with DN19 and the Unichrome Pro video adapter
have the same irq although they are on different busses.

(...)
00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1155
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdffb000 (32-bit, non-prefetchable) [size=512]

01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev
 01) (prog-if 00 [VGA])
        Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
        Capabilities: [70] AGP version 3.0

How can I find out what INT_A/B/C/D line is mapped to what irq?
