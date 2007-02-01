Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXBAESg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXBAESg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030570AbXBAESg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:18:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030536AbXBAES2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:18:28 -0500
Date: Wed, 31 Jan 2007 20:17:09 -0800
From: Andrew Morton <akpm@osdl.org>
To: Len Brown <lenb@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070131201709.14f98fe9.akpm@osdl.org>
In-Reply-To: <200701312310.32828.lenb@kernel.org>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<20070130142714.9f8dd5da.akpm@osdl.org>
	<45C08368.2020904@gmail.com>
	<200701312310.32828.lenb@kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 23:10:32 -0500 Len Brown <lenb@kernel.org> wrote:

> >   CC      arch/i386/kernel/traps.o
> >   CC      arch/i386/kernel/irq.o
> >   CC      arch/i386/kernel/ptrace.o
> >   CC      arch/i386/kernel/time.o
> >   CC      arch/i386/kernel/ioport.o
> >   CC      arch/i386/kernel/ldt.o
> >   CC      arch/i386/kernel/setup.o
> > In file included from include/acpi/acpi.h:62,
> >                  from include/linux/acpi.h:37,
> >                  from arch/i386/kernel/setup.c:31:
> > include/acpi/acpixf.h:100: warning: 'struct acpi_pointer' declared
> > inside parameter list
> > include/acpi/acpixf.h:100: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> > include/acpi/acpixf.h:115: error: expected ')' before 'table_type'
> > make[2]: *** [arch/i386/kernel/setup.o] Błąd 1
> > make[1]: *** [arch/i386/kernel] Błąd 2
> > make[1]: Opuszczenie katalogu `/usr/src/linux-rc'
> > make: *** [debian/stamp-build-kernel] Błąd 2
> > 
> > "Błąd"="Error" (in polish).
> 
> Note that you can always get the latest ACPI patch and drop it directly onto Linus' tree here:
> http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/test/2.6.20/

I'm suspecting that Maciej misapplied the -mm patch somehow:

box:/usr/src/foo> grep acpi_pointer include/acpi/acpixf.h
box:/usr/src/foo> 
