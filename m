Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbXE3Ofi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbXE3Ofi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXE3Of3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:35:29 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45132 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXE3Of2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:35:28 -0400
Date: Wed, 30 May 2007 08:35:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
In-reply-to: <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-id: <465D8BA1.1080800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
References: <465CF794.1070406@shaw.ca>
 <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 29 May 2007, Robert Hancock wrote:
>> This path adds validation of the MMCONFIG table against the ACPI reserved
>> motherboard resources.
> 
> Please fix the formatting of your code.
> 
> "for" and "if" are not functions, and they have a space before the 
> parenthesis.
> 
> And pretty much every single conditional in this patch is spread out over 
> two or more lines and has at least three different indentations. There's 
> something wrong here. Code can't look this bad and still be fine. Some of 
> this looks like random whitespace noise:
> 
> +               if(is_acpi_reserved(cfg->address,
> +                                   cfg->address + size - 1))
> +                       printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
> +                               "in ACPI motherboard resources\n",
> +                               cfg->address);
> +               else {
> 
> That's just horrid. Please try to make the code _look_ nicer.

I'll try and fix up the formatting and repost this patch. I suspect some
of the issues are from the added code clashing with the way the existing
code was formatted.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

