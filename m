Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZHJQcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZHJQcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932150AbZHJQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:32:31 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:43558 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932108AbZHJQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:32:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FPeNlNU4jrvZo7JGFXvpJ+2Aoi4sEvV0So5yCtgj1A6Wzj+DsYlyFcKVA/28XhE/s573LjPPwv9F40z4xOQnOnClVfTa2FtVjJPB88cjIo9R3RTET5+UYucIo6GYo2KO;
Date: Mon, 10 Aug 2009 09:32:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stefan Assmann <sassmann@redhat.com>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
Message-ID: <20090810093228.54406cab@jbarnes-g45>
In-Reply-To: <20090808144520.GB25931@elte.hu>
References: <4A6F5670.4010405@goop.org>
	<20090807103318.06ed3ecd@jbarnes-g45>
	<20090808144520.GB25931@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Corrected Stefan's address.]

On Sat, 8 Aug 2009 16:45:20 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Tue, 28 Jul 2009 12:50:08 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > quirk_reroute_to_boot_interrupts_intel() goes to some effort to 
> > > scan for a bunch of Intel devices and set 
> > > dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However, 
> > > as far as I can see that's the only reference to 
> > > dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the 
> > > whole thing appears to have no effect.
> > > 
> > > Is it all dead code?  Is there something else which should be 
> > > there missing?
> > 
> > Hm my quick look couldn't find a user either.  The initial patch 
> > to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had 
> > an ACPI component, but it looks like that may have vanished 
> > somehow (maybe some of the IOAPIC code got shuffled around and 
> > this bit was missed?).
> > 
> > Stefan or Ingo?
> 
> I dont remember ioapic interactions. Stefan?
> 
> 	Ingo
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
