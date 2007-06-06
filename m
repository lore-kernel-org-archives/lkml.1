Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbXFFO7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbXFFO7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXFFO7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:59:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:3831 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXFFO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M1wRR5shXetPadRgXe1otNUNnwAN2nvI1hmTLz0X/zlPU30lcksbcsP6tXlGVB40OBHacyhX1TjGN+VlTqUEC+/jxhSWWGzfMm/LdZwvvgaaxL/hYfn0TKOwxLAJFFKPh9kNdirkGwdi9DxubLVkOn8m/uIdNTNtPA5s8Bk04FI=
Message-ID: <9a8748490706060759s5d8c43bdoc34334fcf56ee96@mail.gmail.com>
Date: Wed, 6 Jun 2007 16:59:35 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: trenn@suse.de
Subject: Re: Documentation - How to debug ACPI Problems
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <1181140008.28514.259.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181140008.28514.259.camel@queen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Thomas Renninger <trenn@suse.de> wrote:
> Hi,
>
> I made up a little How-To for what I find out is nice to debug ACPI
> problems.
>
Nice :-)

> Any enhancements, corrections, etc. are very much appreciated.
>
See below.

> I'd like to have a final version in the Documentation section.
>
When you send in the patch to add that final version, please also
remember to add an entry to Documentation/00-INDEX

[snip]
>
> How to debug ACPI Problems
> ==========================
>
> Thomas Renninger <trenn@suse.de>, 2007
> Copyright (C) 2007 SUSE Linux GmbH
>
>
> 1. Introduction
> ---------------
>
> 1.1. General Info
> - - - - - - - -
>
Perhaps start out here by telling people what ACPI is. Something like this:

ACPI stands for Advanced Configuration and Power Interface.

> Please refer to the latest ACPI spec for general ACPI information:
> http://www.acpi.info/spec.htm
>
> ACPI is required by most recent x86, x86_64 and IA64 architecture based
> machines.
>
> In general ACPI tables provide information from the BIOS to the OS.
> There are ACPI tables (DSDT and SSDTs), written in the ACPI Source
> Language (ASL) which include byte code (similar to Java byte code) that gets
> interpreted by the OS. The kernel makes use of provided BIOS functions

The word "provided" seems superfluous here.

[snip]
>
> The ACPI tables of your system can be extracted with the acpidump tool:

I think the colon ":" at the end of this line should be removed.

> in the latest pmutils package from here:
> ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils
>
[snip]
>
> In history people used to override their DSDT to workaround BIOS or even kernel

I would replace "In history people used to ..." with "Historically
people used to ...".

[snip]
> If you expect the bug in a module in drivers/acpi/*.c code you might have luck
> and be able to find or narrow down the culprit by simple printks.
>
I would rewrite that bit as :

If you suspect the bug to be in a module in drivers/acpi/*.c code, you
may be able to find or narrow down the culprit simply by adding
printk()'s.

> On more complicated bugs you should make use of the ACPI_DEBUG=y facility.

Maybe just me, but I would say "For" here instead of "On".

[snip]
>          Note: In kernel versions before 2.6.22 the boot parameters are:

should be "...the boot parameters were:" - past tense.

[snip]
>          interface (Documentation/networking/netconsole.txt) to write away
>          syslog messages over network or firescope

"... to write away syslog messages over network ..." sounds a little
clumsy to me. Why not simply write "... to send syslog messages over
network ..." ?

> (patches already exist in
>          2.6.22-rcX-mm?) to send syslog messages over firewire.
>          The latter might be the only way to debug early hangs on laptops
>          without serial console anyway.
>

"without a serial console" ???

>    3.2.2 Using ACPI_DEBUG Boot Parameters via /sysfs and /proc
>
>          The same as 3.2.1., you can also pass the parameters at runtime e.g.
>          via:
>          echo 0x1F >/proc/acpi/debug_level    # before 2.6.22 or
>          echo ?!?  >/sys/?/!/?                # Rui?

Seems like some bits are missing here ^^^

>          Wrapping such statements around loading and unloading a bug affected
>          ACPI module might give you the possibility to increase debug_level,
>          but still only give you a managable amount of debug output.
>

s/managable/manageable/


[snip]

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
