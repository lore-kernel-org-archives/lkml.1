Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXDOPuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXDOPuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXDOPuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:50:23 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:54011 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbXDOPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:50:23 -0400
Date: Sun, 15 Apr 2007 09:50:16 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Marat Buharov <marat.buharov@gmail.com>,
       Marc Donner <Marc.Donner@dbd-breitband.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.6 vanilla does't boot
Message-ID: <20070415155016.GA14489@ellpspace.math.ualberta.ca>
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com> <C244E4A2.1CF94%Marc.Donner@dbd-breitband.de> <a872555b0704122246n7be574e7mc53920d6e446f86@mail.gmail.com> <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com> <a872555b0704130438p602b8acbg520871d692266309@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a872555b0704130438p602b8acbg520871d692266309@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 03:38:18PM +0400, Denis Kirjanov wrote:
> I updated the BIOS to the latest version, but the problem persists.
> Boots option pci = noacpi not solved the problem. Reporting bios bug
> disappears when setting pci = nommconf, But the kernel is still not
> loaded (

On x86_64 hardware using ata_piix I was unable to boot kernels
based on the current 2.6.20.x either.  Regardless of extra kernel
parameters used I was getting consistently 'hdc: lost interrupt',
and/or similar and after something like that the whole machine
was dead.  The only differences were if I could still reboot
from a keyboard or if I really have to pull a plug.

A kernel derived from 2.6.21-rc6-git1 (2.6.20-1.3053.fc7.x86_64 from
Fedora "rawhide" to be more precise) did boot on the hardware in
question, though; but only when I gave it 'acpi=off'.  Without that
parameter it was getting stuck apparently when starting hotplug.
In that kernel case disks were accessed using pata_atiixp driver.

   Michal
