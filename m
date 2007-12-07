Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXLGVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXLGVlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXLGVl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:41:28 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:34674 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbXLGVl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:41:27 -0500
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0712072229280.26862@pademelon.sonytel.be>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
	 <Pine.LNX.4.62.0712072229280.26862@pademelon.sonytel.be>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Dec 2007 16:33:45 -0500
Message-Id: <1197063225.6078.54.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-07 at 22:30 +0100, Geert Uytterhoeven wrote:
> On Sat, 8 Dec 2007, Balbir Singh wrote:
> > +	if (strstr(p, "fake="))
> > +		cmdline = p + 5;	/* 5 is faster than strlen("fake=") */
> 
> Really? My gcc is smart enough to replace the `strlen("fake=")' by 5, even
> without -O.

If some odd reason it doesn't replace it wouldn't it be smarter to do
sizeof("fake="); It should definitely optimize that away to a constant
value and its less prone to error if the string in strstr changes.

> 
> With kind regards,
>  
> Geert Uytterhoeven
> Software Architect
> 
> Sony Network and Software Technology Center Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
>  
> Phone:    +32 (0)2 700 8453	
> Fax:      +32 (0)2 700 8622	
> E-mail:   Geert.Uytterhoeven@sonycom.com	
> Internet: http://www.sony-europe.com/
>  	
> Sony Network and Software Technology Center Europe	
> A division of Sony Service Centre (Europe) N.V.	
> Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
> VAT BE 0413.825.160 · RPR Brussels	
> Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

