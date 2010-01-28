Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017Ab0A1UfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0A1UfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343Ab0A1UfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:35:15 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:35088 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753313Ab0A1UfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:35:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Tl9Qec6WmTBG23WTA++moBk6TbcOyrmdb9t1SwnGgVU0GWymDrnsLKlPyC5LQ1Kua/xa4w+cJJCo1Yul3o0I39Z7pmgO8r8WVwTbG44yyCaBAmWTmD/VUyD0OyTzivmJ;
Date: Thu, 28 Jan 2010 12:35:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100128123507.2d6a3b33@jbarnes-piketon>
In-Reply-To: <201001282128.33389.rjw@sisk.pl>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<4B61D554.9000003@kernel.org>
	<20100128110331.61455a15@jbarnes-piketon>
	<201001282128.33389.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 21:28:33 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > But disabling it gets us into trouble too.  When platforms are
> > designed for Linux, they may be designed to have ACPI disabled
> > (though this is probably rare for general purpose PCs and servers).
> 
> Well, not quite.  On recent SMP systems it's next to impossible to
> get all of the necessary system configuration information without
> ACPI, since it only is provided by the ACPI tables (the configuration
> of APICs, interrupt routing, CPU C states, other stuff).
> 
> [BTW, I think it's better to CC linux-acpi and Len at this point.]

I was thinking more of custom designed low power servers or something,
possibly running LinuxBIOS or some other custom BIOS.  For a general
purpose machine though I'm 100% agreed.  ACPI is required these days
for PCs.

I was trying to make a point that we shouldn't disable ACPI on
platforms that support it.  Rather, we should fix any bugs we discover
in handling ACPI correctly, rather than working around it by turning it
off.

-- 
Jesse Barnes, Intel Open Source Technology Center
