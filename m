Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586Ab0A1SQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0A1SQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0A1SQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:16:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:49763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab0A1SQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:16:26 -0500
Message-ID: <4B61D3C6.1050104@kernel.org>
Date: Thu, 28 Jan 2010 10:13:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Jeff Garrett <jeff@jgarrett.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>	<201001261348.59508.rjw@sisk.pl>	<201001261032.37053.bjorn.helgaas@hp.com>	<201001261902.13911.rjw@sisk.pl>	<20100126101752.78196900@jbarnes-piketon>	<4B5F735B.2040308@kernel.org>	<alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>	<20100127192409.79af96db@jbarnes-piketon>	<20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon>
In-Reply-To: <20100128082432.05a97ebc@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 08:24 AM, Jesse Barnes wrote:
> On Wed, 27 Jan 2010 22:02:26 -0600
> jeff@jgarrett.org (Jeff Garrett) wrote:
> 
>> On Wed, Jan 27, 2010 at 07:24:09PM -0800, Jesse Barnes wrote:
>>> On Wed, 27 Jan 2010 17:50:17 -0800 (PST)
>>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> On Tue, 26 Jan 2010, Yinghai Lu wrote:
>>>>>
>>>>> [PATCH] x86/pci: don't use ioh resource if only have one ioh
>>>>
>>>> Please, no.
>>>>
>>>> This patch is too ugly to live.
>>>>
>>>> And it's totally unacceptable to probe every single possible PCI device 
>>>> for something like this.
>>>>
>>>> If we don't know enough about the hardware workings of those Intel bridges 
>>>> to know when they are active and how they decode things, then please let's 
>>>> just disable intel_bus.c entirely.
>>>>
>>>> There's no excuse for hacky tests like this.
>>>
>>> Ok, we'll just kill it entirely then.  I'll send a patch tomorrow
>>> unless Yinghai beats me to it.
>>
>> What about something like this (works for me, without pci=use_crs)?
>>
>> ---
>>     Remove intel_bus.c Intel-specific PCI/IOH logic
>>     
>>     Signed-off-by: Jeff Garrett <jeff@jgarrett.org>
> 
> Yeah, looks good.  I'll push to Linus today.
> 

please don't. will send you another patch, to keep the print out so we can cross check the _CRS.

YH
