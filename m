Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492Ab0ATFHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0ATFHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 00:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330Ab0ATFHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 00:07:01 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:43954 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0ATFHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 00:07:00 -0500
Date: Wed, 20 Jan 2010 00:06:49 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
In-reply-to: <4B45001E.7000404@zytor.com>
Message-id: <alpine.LFD.2.00.1001200003520.4265@localhost.localdomain>
References: <20100104162114.GA30113@percival.namespace.at>
 <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
 <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org>
 <20100106143640.GB13984@srcf.ucam.org>
 <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain>
 <20100106193608.GA21447@srcf.ucam.org>
 <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
 <4B45001E.7000404@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about using _OSI() with a *blacklist*, i.e. treat _OSI("Unknown
> String") as "new enough", whereas _OSI("Windows 2000") is ignored?

Sound reasoning, but I think that parsing the _OSI strings presented
by the BIOS so that the OS can deving whether it is a Windows XP
box or newer is more complicated than this problem merits.

I recommend that we compare DMI date with 2003 and go from there.
If we find that doesn't work, we can apply additional cleverness.

-Len Brown
Intel Open Source Technology Center

