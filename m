Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbYBGXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbYBGXSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933967AbYBGXSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:18:33 -0500
Received: from cyberslack.slackadelic.com ([216.23.240.152]:35636 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbYBGXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:18:31 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Thu, 7 Feb 2008 23:18:27 +0000
User-Agent: KMail/1.9.7
Cc: Len Brown <lenb@kernel.org>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <200802071727.38743.lenb@kernel.org> <20080207223455.GB6096@elf.ucw.cz>
In-Reply-To: <20080207223455.GB6096@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072318.28313.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 22:34:55 Pavel Machek wrote:
>  +3) What is the ACPI-WMI mapper
>  +
>  +The Linux ACPI-WMI driver is the implementation of this mapper for Linux.
>
> Yes, please. This needs translation into plain english.

In plain English? ACPI-WMI is a nasty hack/ abuse of ACPI by Microsoft to 
force their driver model into ACPI, and that should be thoroughly discouraged 
from further use.

However, since quite a few laptop vendors rely on it for basic functionality, 
we have to implement it (or a part of it) as well.

Yes, WMI itself is supposed to be an instrumentation/ management thing, as 
well as, if I understand, part of their driver model, and ACPI-WMI is a part 
of that - by and of itself though, ACPI-WMI is _not_ the whole of WMI.

All that the Linux driver currently cares about is translating this crap into 
something that we can actually use in Linux to make hardware work (kernel 
space). So at the moment, ACPI-WMI is exactly what it says it is - not a lot. 
It needs another driver on top to do something useful (e.g. acer-wmi, 
tc1100-wmi).

Later on, we will try and replicate the rest of the 'specification', which is 
supposed to export all this rubbish (data, and direct access to various ACPI 
methods defined in a WMI device) to userspace.

> What is WBEM, in plain terms? What is it good for?

If you can make heads or tails of WBEM, please feel free to let me know.

AFAICT, it's supposed to be a means of providing some sort of web based 
management/ instrumentation.

So yes, I agree with you the documentation is crap - but it needs to be redone 
anyway, and I've already had that pointed out to me.

As for the Kconfig - I'm open to suggestions.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
