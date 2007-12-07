Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXLGVbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXLGVbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXLGVa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:30:59 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63760 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752099AbXLGVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:30:58 -0500
Date: Fri, 7 Dec 2007 22:30:53 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
In-Reply-To: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
Message-ID: <Pine.LNX.4.62.0712072229280.26862@pademelon.sonytel.be>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1040896501-1197063053=:26862"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1040896501-1197063053=:26862
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 8 Dec 2007, Balbir Singh wrote:
> +	if (strstr(p, "fake="))
> +		cmdline = p + 5;	/* 5 is faster than strlen("fake=") */

Really? My gcc is smart enough to replace the `strlen("fake=")' by 5, even
without -O.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1040896501-1197063053=:26862--
