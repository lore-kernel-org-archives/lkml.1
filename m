Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYGYWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYGYWLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYGYWLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:11:07 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:27984 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYGYWLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:11:06 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <488A4F70.4010208@tremplin-utc.net>
Date: Sat, 26 Jul 2008 00:10:56 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080725 Mandriva/2.0.0.16-1mdv2009.0 (2009.0) Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown schreef:
> Thomas,
> 
> re: OSI(Windows...)
> 
> Linux will continue to claim OSI compatibility with Windows
> until the day when the majority of Linux systems
> have passed a Linux compatibility test rather than
> a Windows compatibility test.
> 
> Re: OSI(Linux)
> 
> I've looked at O(100) DSDT's that look at OSI(Linux),
> and all but serveral systems from two vendors do it by mistake.
> They simply copied it from the bugged Intel reference code.
> 
> OSI(Linux) will _never_ be restored to Linux, ever.
> 
Just out of curiosity, let's imagine that today HP decides to fix its 
BIOS. What would be the way to do it? Of course, without putting 
additional problems when Windows is booted.

What they would want is to provide workarounds for each given version of 
Windows and provide a completely ACPI-compliant version when Linux is 
running. I fail to see how it is possible possible to do that today.
Well... they could detect Linux by checking that several OSI's for 
Windows pass, but that would be really a nasty kludge.

So, am I understanding correctly that we are in a desperate need for a 
good OSI solution? Until then, we can only bash and complain at the BIOS 
developers, but they have no way to fix the problems.

Eric
