Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbZDIOvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbZDIOvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762698AbZDIOvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:51:39 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55942 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756637AbZDIOvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:51:37 -0400
Date: Thu, 9 Apr 2009 16:51:35 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: [BUILD FAILURE 05] Next April 9 : PPC64 randconfig
 [drivers/net/wan/wanxlfw.inc]
In-Reply-To: <1239285437.5188.68.camel@subratamodak.linux.ibm.com>
Message-ID: <alpine.LRH.2.00.0904091650060.4839@vixen.sonytel.be>
References: <1239285152.5188.66.camel@subratamodak.linux.ibm.com> <1239285437.5188.68.camel@subratamodak.linux.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Subrata Modak wrote:
> Observed the following error:
> 
> BLD FW  drivers/net/wan/wanxlfw.inc
> /bin/sh: as68k: command not found
> make[3]: *** [drivers/net/wan/wanxlfw.inc] Error 127
> make[2]: *** [drivers/net/wan] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Yeah, if you enable CONFIG_WANXL_BUILD_FIRMWARE without
CONFIG_PREVENT_FIRMWARE_BUILD (the trick for allmodconfig?), you need the
appropriate tools installed...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
