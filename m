Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbYGPQHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbYGPQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGPQHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:07:05 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:55109 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757288AbYGPQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:07:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=LYBknT2iJfVNGDE5qQoUmiIZwIiIwRItS00nYyiR8KeY//kh64QggpYzFZ0lda1tZ6Huvpp8bZGFZOR4Vq6Km3XkZvCaA/ym7A88PzJ6KG3XyAZclQjrAn6SbJDOen80;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: acpi based pci gap calculation  - v3
Date: Wed, 16 Jul 2008 09:06:43 -0700
User-Agent: KMail/1.9.9
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
References: <1216148382.6135.21.camel@alok-dev1> <200807151553.41403.jbarnes@virtuousgeek.org> <487D89E3.9070604@linux.intel.com>
In-Reply-To: <487D89E3.9070604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160906.43632.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2008 10:40 pm Andi Kleen wrote:
> Jesse Barnes wrote:
> > On Tuesday, July 15, 2008 1:54 pm Alok Kataria wrote:
> >> I have tested it with couple of different BIOS settings and it seems to
> >> work as it should.
> >>
> >>> Most of the PCI bugs we
> >>> have at the moment are related to PCI resource allocation failures.  My
> >>> hope is that finding more space will fix most of them.  Assuming this
> >>> patch doesn't have any dependencies, I can put it in my linux-next
> >>> branch.
> >>
> >> No dependencies, I had added a function e820_search_gap which is used by
> >> this patch. This function is already in the mainline tree.
> >> Thanks for applying.
> >
> > Ok, I stuffed it in my linux-next branch.  I'll let it sit there for a
> > day or so though, just to shake out any build problems etc. in linux-next
> > before asking Linus to pull the whole lot.
>
> For me it seems a little risky to push up that early. I think it would
> be better to let it sit longer in linux-next for this. After all this is
> a major change how IO resources are allocated. That is why I didn't pull
> it into the ACPI release branch.

The only problem there is that linux-next doesn't get nearly the sort of 
testing coverage we need for this kind of change.  It's also small, and 
reverting it is easy, so if we run into big problems that we can't fix we can 
always back it out...

I'm interested in hearing people's thoughts on this.

Jesse
