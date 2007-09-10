Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXIJQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXIJQ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXIJQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:26:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39760 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753390AbXIJQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:26:04 -0400
Date: Mon, 10 Sep 2007 17:33:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: PnP driver <mkrameshid@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Calling PnP bios routines like get device node from x86_84 arch
Message-ID: <20070910173344.4bd2ae9e@the-village.bc.nu>
In-Reply-To: <12594726.post@talk.nabble.com>
References: <12594726.post@talk.nabble.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 08:06:20 -0700 (PDT)
PnP driver <mkrameshid@gmail.com> wrote:

> 
> Hi,    
>       I am very new to linux kernel driver development. I need to develop a 
> driver for calling  BIOS routines like get device node. I could  call  it
> in i386 architecture using the PnP driver. 

We use ACPI on AMD64 so you should be parsing the ACPI tables not trying
to rely on legacy interfaces which if I rememeber the spec rightly aren't
even guaranteed safe to call when ACPI is active.

What are you actually trying to achieve.

>      But in x86_64 arch I couldn't see any support. Even I tried to
> implement it similar to the i386. But there is no API get_cpu_gdt_table().
> Is there any other way to get the cpu_gdt_table? or any other way to 
> call the BIOS routines.

Assuming you even have a BIOS - you may have EFI underlying or
Linuxbios or be a virtual machine.
