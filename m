Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbYLAF6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbYLAF6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 00:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAF6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:58:34 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45725 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYLAF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:58:33 -0500
Date: Mon, 1 Dec 2008 06:54:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH] x86: create drivers/x86/ from drivers/misc/
Message-ID: <20081201055406.GB21782@uranus.ravnborg.org>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au> <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain> <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain> <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain> <20081128223533.GA5175@uranus.ravnborg.org> <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain> <20081129073816.GB8351@uranus.ravnborg.org> <alpine.LFD.2.00.0811302338450.3314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811302338450.3314@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 12:00:04AM -0500, Len Brown wrote:
> > 
> > Any chance we can have this in drivers/Kconfig?
> > 
> > Just wrap all of the file in an
> > 
> > if X86
> > .....
> > endif
> > 
> > So we keep all the drivers/ stuff in one Kconfig file and
> > not spread all over.
> 
> grep 'source "drivers"' arch/x86/Kconfig 
> 
> source "drivers/acpi/Kconfig"
> source "drivers/cpuidle/Kconfig"
> source "drivers/idle/Kconfig"
> source "drivers/pci/pcie/Kconfig"
> source "drivers/pci/Kconfig"
> source "drivers/eisa/Kconfig"
> source "drivers/mca/Kconfig"
> source "drivers/pcmcia/Kconfig"
> source "drivers/pci/hotplug/Kconfig"
> source "drivers/Kconfig"
> source "drivers/firmware/Kconfig"
> source "drivers/x86/Kconfig"
> 
> Are the lines above a good example, a bad example,
> or did I miss a nuance of the grand Kconfig design?

Unfortunately a typical example but if you look
closer most of the above is bus stuff, not driver stuff.

This is not the easist part to deal with
as there are > 10 arch to synchronize.

	Sam
