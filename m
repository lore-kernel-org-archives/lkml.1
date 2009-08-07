Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZHGRdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZHGRdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZHGRdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:33:22 -0400
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:59086 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753139AbZHGRdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:33:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qLwmqgiSk+qC3UofqgVmkd0bNSu+5so7yCvpDu1n3DdgD1s6BL/eTYDN5RvUaggIrahYULNI9F62w7a0CJvbtNonRKDXDaXTBDdVGfsPmoe6/Ip3v/fXCvNHkrq86ETj;
Date: Fri, 7 Aug 2009 10:33:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stefan Assmann <sassmann@suse.de>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
Message-ID: <20090807103318.06ed3ecd@jbarnes-g45>
In-Reply-To: <4A6F5670.4010405@goop.org>
References: <4A6F5670.4010405@goop.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 12:50:08 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> quirk_reroute_to_boot_interrupts_intel() goes to some effort to scan
> for a bunch of Intel devices and set dev->irq_reroute_variant =
> INTEL_IRQ_REROUTE_VARIANT.  However, as far as I can see that's the
> only reference to dev->irq_reroute_variant and
> INTEL_IRQ_REROUTE_VARIANT, so the whole thing appears to have no
> effect.
> 
> Is it all dead code?  Is there something else which should be there
> missing?

Hm my quick look couldn't find a user either.  The initial patch to add
that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had an ACPI
component, but it looks like that may have vanished somehow (maybe
some of the IOAPIC code got shuffled around and this bit was
missed?).

Stefan or Ingo?

-- 
Jesse Barnes, Intel Open Source Technology Center
