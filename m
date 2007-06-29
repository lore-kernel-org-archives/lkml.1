Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXF2Lto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXF2Lto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbXF2Ltg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:49:36 -0400
Received: from messidor.freesurf.fr ([212.43.206.29]:40362 "EHLO
	smtp-out.freesurf.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758138AbXF2Ltf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:49:35 -0400
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 07:49:35 EDT
Message-ID: <48440.194.254.4.171.1183116296.squirrel@jose.freesurf.fr>
Date: Fri, 29 Jun 2007 13:24:56 +0200 (CEST)
Subject: 2.6.21-rt9 problem : xruns
From: <skyball000@freesurf.fr>
To: <linux-kernel@vger.kernel.org>
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
X-Mailer: SquirrelMail (version 1.2.5)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've recently compiled a "vanilla" 2.6.21 kernel, patched with Ingo Molnar's
rt-8 patch, as I was unable to compile with rt-7.

I needed it because I'm using audio applications (tests were made with
FrugalWare, but I don't think it's a distro issue).

Everything was allright until I changed my motherboard for an  Asrock
4coreDual-Vsta (I formerly used a Nforce4 one), with VIA PT880 Ultra chipset.

I've justed switched the hardware, as Linux is neat enough to boot without
having to reinstall the whole OS.

Since, I get tons of xruns when using RT applications, and the only solution
I've found to "fix" it was to disable ACPI at boot time.
Moreover, I get this message at boot time :
PCI: BIOS bug: MCFG area@e0000000 is not E820 reserved
PCI: not using MMCONFIG

I've also tested this hardware setup with a UbuntoStudio kernel (2.6.19),
and everything works flawlessy (no XRUNS, no kernel messages) !

So here is my question (I'd like to understand what's happening) :
   - is it a kernel (or patch) issue ?
   - is it a bad chipset support in the latest kernel versions ?
   - could this be related to BIOS issues only (I've tried all available
versions without any change) ?
   - should I use special settings in the ".config" in order to avoid these
problems ?

I wasn't able to detect what causes these XRUNS, so if anyone has clues ...

Regards
skb





