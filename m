Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXEADGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXEADGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEADGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:06:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46350 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXEADGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:06:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com>
	<4636A332.2070101@zytor.com>
	<m1odl51dci.fsf@ebiederm.dsl.xmission.com>
	<20070501034612.GK25929@bingen.suse.de>
Date: Mon, 30 Apr 2007 21:06:11 -0600
In-Reply-To: <20070501034612.GK25929@bingen.suse.de> (Andi Kleen's message of
	"Tue, 1 May 2007 05:46:12 +0200")
Message-ID: <m1hcqx1bvg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> Not that the x86 BIOS is bad.  It is nearly a marvel in it's simplicity
>> and ubiquitousness, 
>
> Simplicity? That must be why x86 motherbords are shipping with (compressed) 
> 8MB BIOS flash chips now.

Those would be 8 megabit chips, and those would be server motherboards
you are looking.  Most likely the ones that are starting to think ahead
to EFI support.

There are thread jobs the firmware on a PC does.
- Configure the hardware to look like a PC.
  What with memory controller setup and the like that is the hard
  part and the bulk of the work.

  Since this is written quickly and in assembler it has likely descended
  into spaghetti by now.

- Whatever ACPI does. suspend/resume and etc.

- Provide a subroutine library for boot loaders.
  That subroutine library is what gets exposed.

Now if you compare what it takes to implement the PC BIOS interface
the "subroutine library for bootloaders"  with EFI, or open firmware
or a real OS you will quickly see how very small and simple it is.  It
isn't a beautiful interface but it is short and to the point.

Eric
