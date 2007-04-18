Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXDRTlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXDRTlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXDRTlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:41:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbXDRTlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:41:03 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Subject: Re: 2.6.20.6 vanilla does't boot
Date: Wed, 18 Apr 2007 15:39:25 -0400
User-Agent: KMail/1.9.5
Cc: Denis Kirjanov <kirjanov@gmail.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Marc Donner <Marc.Donner@dbd-breitband.de>,
       linux-kernel@vger.kernel.org
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com> <a872555b0704130438p602b8acbg520871d692266309@mail.gmail.com> <20070415155016.GA14489@ellpspace.math.ualberta.ca>
In-Reply-To: <20070415155016.GA14489@ellpspace.math.ualberta.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181539.26105.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 11:50, Michal Jaegermann wrote:
> On Fri, Apr 13, 2007 at 03:38:18PM +0400, Denis Kirjanov wrote:
> > I updated the BIOS to the latest version, but the problem persists.
> > Boots option pci = noacpi not solved the problem. Reporting bios bug
> > disappears when setting pci = nommconf, But the kernel is still not
> > loaded (

The 2.6.15 dmesg do not give any clues to why 2.6.20.6 would not boot.
Can you boot 2.6.20.6 with "debug" and capture the serial console log,
or take a photo of what is on the screen when the boot hangs?

Did anything between 2.6.15 and 2.6.20.6 work properly?
Can you bisect where the failure started?

> On x86_64 hardware using ata_piix I was unable to boot kernels
> based on the current 2.6.20.x either.  Regardless of extra kernel
> parameters used I was getting consistently 'hdc: lost interrupt',
> and/or similar and after something like that the whole machine
> was dead.  The only differences were if I could still reboot
> from a keyboard or if I really have to pull a plug.
> 
> A kernel derived from 2.6.21-rc6-git1 (2.6.20-1.3053.fc7.x86_64 from
> Fedora "rawhide" to be more precise) did boot on the hardware in
> question, though; but only when I gave it 'acpi=off'.  Without that
> parameter it was getting stuck apparently when starting hotplug.
> In that kernel case disks were accessed using pata_atiixp driver.

If "acpi=off" is necessary to boot the latest kernel, please
report an ACPI bug:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
Please mention in the bug report what the latest working kernel was.

thanks,
-Len

