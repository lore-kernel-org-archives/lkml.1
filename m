Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZI1DeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZI1DeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZI1DeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:34:23 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:59699 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZI1DeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:34:22 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Fai024BsFsjncI9xe16+DQ)"
Date: Sun, 27 Sep 2009 23:34:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] thinkpad-acpi: Fix build on
 !CONFIG_THINKPAD_ACPI_HOTKEY_POLL
In-reply-to: <20090927122828.GA24783@khazad-dum.debian.net>
Message-id: <alpine.LFD.2.00.0909272331520.5561@localhost.localdomain>
References: <200909260519.n8Q5JrB6016778@hera.kernel.org>
 <20090927075254.GA20847@elte.hu> <20090927122828.GA24783@khazad-dum.debian.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Fai024BsFsjncI9xe16+DQ)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT


> > >  drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
> > 
> > -tip testing found that these changes caused a build failure 
> > in drivers/platform/x86/thinkpad_acpi.c when 
> > !CONFIG_THINKPAD_ACPI_HOTKEY_POLL - the fix is attached  below.
> 
> Fixed by a different patch, which will hit mainline soon....

Ingo,
2.6.32-rc1 should build fine* -- let me know if it doesn't.

thanks,
Len Brown, Intel Open Source Technology Center

* module this message, which Henruque assures me will go away soon
drivers/platform/x86/thinkpad_acpi.c:2225: warning: 
¡tpacpi_hotkey_driver_mask_set¢ defined but not used

--Boundary_(ID_Fai024BsFsjncI9xe16+DQ)--
