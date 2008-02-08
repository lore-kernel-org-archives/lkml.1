Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYBHVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYBHVSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYBHVS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:18:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42692 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYBHVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:18:25 -0500
Message-ID: <47ACC718.5060508@zytor.com>
Date: Fri, 08 Feb 2008 13:18:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <47AB975C.1010902@zytor.com> <20080208070419.GA4544@ucw.cz> <200802081723.16354.rjw@sisk.pl> <20080208210004.GA12923@elf.ucw.cz> <47ACC381.9070601@zytor.com> <20080208210905.GB12923@elf.ucw.cz>
In-Reply-To: <20080208210905.GB12923@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> 
> Indirect call from where?
> 
> BIOS jumps to address you provide.
> 
>> Where is this code?
> 
> arch/x86/kernel/acpi/realmode/wakeup.S
> 
> BIOS jumps to wakeup_code. With CS=something, IP=0. If wakeup code is
> at other address than zero, I'll not be able to easily address data
> below it.
> 								Pavel

Ah, okay.  Yes, the canonical way to deal with that is to put a short 
jump at the top.

	-hpa
