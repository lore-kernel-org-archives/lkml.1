Return-Path: <linux-kernel-owner+w=401wt.eu-S1750744AbXBMPb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750744AbXBMPb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXBMPb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:31:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXBMPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:31:27 -0500
Subject: current git crashes on bootup with pci_iounmap()
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 16:31:54 +0100
Message-Id: <1171380714.3829.6.camel@pim.off.vrfy.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:4ddcc9dd12ba6cf3155e4d81b383efda
X-Provags-ID2: V01U2FsdGVkX18VFkDKMepjOVkHb/AQBQvsg36pgJuGlhVf2C6k7xv2LO7grpW6WJUzFOJiNktrim10EID1OcoWiJkUwDEpFckuZmoj9WOIz1AaPERqQbwK/w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel BUG at lib/iomap.c:254!
invalid opcode: 0000 [#1]
...

The screen picture is here:
  http://vrfy.org/pci_iounmap.jpg

It's a Thinkpad T43p.

2.6.20 was working fine.

Commenting out:
  IO_COND(addr, /* nothing */, iounmap(addr));
in:
  lib/iomap.c:254
makes at least booting up possible.

Thanks,
Kay

