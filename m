Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbXFBLIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbXFBLIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 07:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXFBLIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 07:08:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:2458 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbXFBLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 07:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GB3DYmgRzwrZePKZrcn7VxkYU2IoEdlze1PeICEztr89VL3bWCvkJ1mY70Zdu80z/KqlBOPMHbBQLQgJaBXXKPFLCPgmNExBFXx6dP2y7KUwAed9UtgRS0WqNhhPx3G9ODz4eiTaZ7Vx7iwKhnEhPKWIDpALaCJW9SXh9xz/yn4=
Message-ID: <8956d4ca0706020408y4ddcea6ap35c8b7dee3fcbe32@mail.gmail.com>
Date: Sat, 2 Jun 2007 21:08:18 +1000
From: "Mitch Davis" <mjd-kernel@afork.com>
To: "Olaf Dietsche" <olaf+list.linux-acpi@olafdietsche.de>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200706020037.16615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <878xb35sje.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl>
	 <87hcpr2ubl.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl>
X-Google-Sender-Auth: 19a2f8fd11cad930
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olaf,

I'm also having troubles with the resume part of STR, although since
your hardware is significantly different to mine, the cause is likely
to be different.

On 6/2/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >>
> > >> > On Friday, 1 June 2007 22:27, Olaf Dietsche wrote:
> > >> >> When I resume, everything seems to come up (fan becomes busy, disk and
> > >> >> dvd spin up for a short time),
>
> First, you can check if the patch
>
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/20-ACPI-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
>
> helps, by chance.

(Rafael's suggestion may help you but it didn't help me)

> Second, you can use PM_TRACE (Documentation/power/s2ram.txt) to find the
> place where it really fails.

I modified my kernel source so it uses PM_TRACE to trace both the
suspend, and whether the BIOS ever jumps back into the kernel on
resume.  (In my case, I don't think the BIOS is doing the jump).

I also compiled with only the bare minimum of options turned on, and
use an initramfs to rule out device interactions.

If what I did is useful to you, you can find it here:

  http://bugzilla.kernel.org/show_bug.cgi?id=7988

And if you haven't already (and your problem occurs with a stock
kernel), you might want to log this as a bug like I did.

Hope this helps.

Mitch.
