Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXHKEyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXHKEyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 00:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXHKEyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 00:54:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:42415 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbXHKEyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 00:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ssqnsxwUPp675SA9HQ8QOCwslSaudlAZtQALYXtcfxB78vyC6RrOdmm4tBM4TG6m9mBNcuA6OfSni1vCLBICyLeqTGiCg3nMU5Z5ZIvDomG9bUPnix4ZZiIjI0ZxZAt7TYiCBRgCGfyJqmLDthRS3gOmSbifKlvCjvrKJ5WtBMU=
Message-ID: <86802c440708102154r59e1acbj90fa0d5b73197fb9@mail.gmail.com>
Date: Fri, 10 Aug 2007 21:54:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: Serial ports rearranged in 2.6.22?
In-Reply-To: <20070810213925.GB10855@elmicha>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070810213925.GB10855@elmicha>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Michael Mauch <michael.mauch@gmx.de> wrote:
> Hi,
>
> until 2.6.21, I had the normal assignments for ttyS0 and ttyS1:
>
> 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>
> With 2.6.22 I get the names <-> ports/irqs the other way around:
>
> 00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
> 00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
>
> Is this supposed to be that way? Should we reassign these names with
> udev? udev-114 doesn't seem to have built-in rules to assign the
> traditional names.
>
> Or could it be related to some brokeness in my BIOS (ACPI/PNP)?
>
> I'm using the 8250_pnp module (and it's the same with builtin serial
> modules). I made sure that I did not accidentally change the BIOS
> settings for the serial ports.
>
> I'm using Gentoo, but on the lirc list was a Fedora user with the same
> symptoms.

http://lkml.org/lkml/2007/7/25/455

YH
