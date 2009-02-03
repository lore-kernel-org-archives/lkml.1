Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZBCVEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZBCVEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBCVDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:03:55 -0500
Received: from www.tglx.de ([62.245.132.106]:56885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZBCVDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:03:54 -0500
Date: Tue, 3 Feb 2009 22:03:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ruby <rubys@intertwingly.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
In-Reply-To: <20090203114849.b661f1ce.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
References: <4978767D.4060700@intertwingly.net> <20090130000758.1dff0113.akpm@linux-foundation.org> <498885CC.4060509@intertwingly.net> <20090203114849.b661f1ce.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Andrew Morton wrote:
> > >> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > >> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
Sigh.

> Not sure.  Perhaps platform_i386/platform_x86_64 would be correct.
> Can the x86 maintainers please advise?

Yup. That's correct

@Sam: I just checked, that your machine has a serial port. That's a
good start :)

Do you have a second computer around with a serial port ? If yes, then
please add the following to the kernel command line:

       earlyprintk=serial,ttyS0,115200 apic=debug

and connect the serial ports with a null modem cable. Fire up a
terminal program on the second machine and capture the output.

Thanks,

	tglx
