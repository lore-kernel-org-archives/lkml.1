Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYAQAUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYAQAUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYAQAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:20:26 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58655 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYAQAUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:20:25 -0500
Date: Wed, 16 Jan 2008 16:26:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/2] x86: MMCONF enable MCFG early
In-reply-to: <200801161409.02591.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-id: <200801161626.19991.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801161405.17889.yinghai.lu@sun.com>
 <200801161406.38946.yinghai.lu@sun.com> <200801161409.02591.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 02:09:02 pm Yinghai Lu wrote:
> [PATCH] x86: MMCONF enable MCFG early
> 
> patch
> 	x86: validate against ACPI motherboard resources
> 
> changed the mmconf init sequence, and init MMCONF late in acpi_init.
> 
> here change it back to old sequence
> 1. check hostbridge in early
> 2. check MCFG with e820 in early
> 3. if all fail, will check MCFg with acpi _CRS in acpi_init
> 
> So we can make MCONF working again when acpi=off is set if hostbridge support that.
> 

Ingo,
it seems you removed
> patch
> 	x86: validate against ACPI motherboard resources
last night. 

was it dropped?

YH
