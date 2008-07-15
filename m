Return-Path: <linux-kernel-owner+w=401wt.eu-S1762525AbYGOU2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762525AbYGOU2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYGOU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:28:26 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:53653 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753346AbYGOU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:28:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=MVH4cB5TtsPuZ93sI9oCuVqjORFDap4O6EVM3Mo13EMF2X3JlUkhijAP0SyXnMBHSjXG63wl10KoFga1UUu9iF7j7i5NFO+d2LKjnb/q1LL+U8ddTBqUz5PQTB0LB01G;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akataria@vmware.com
Subject: Re: acpi based pci gap calculation  - v3
Date: Tue, 15 Jul 2008 13:28:00 -0700
User-Agent: KMail/1.9.9
Cc: ak@linux.intel.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, linux-pci@vger.kernel.org,
       TJ <linux@tjworld.net>
References: <1216148382.6135.21.camel@alok-dev1>
In-Reply-To: <1216148382.6135.21.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151328.00739.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2008 11:59 am Alok Kataria wrote:
> Hi Andi,
>
> I don't see this patch being applied in any of the tree yet.
> Resending this incase you guys might have missed it.
> I assume this will go through the ACPI tree.
>
> The need for this patch was explained in
> http://marc.info/?l=linux-kernel&m=121441818818598&w=2
>
> The v2 patch was discussed in
> http://marc.info/?l=linux-acpi&m=121433339619175&w=2
>
> I then sent a incremental patch on top of v2 to fix some conditions and
> handle the change in the e820_search_gap interface.
>
> In this v3 patch, i have folded the incremental fix into the v2 patch.
> Please apply this.

This should probably go to linux-pci too.

I wonder if this is stable enough to go into 2.6.27?  Most of the PCI bugs we 
have at the moment are related to PCI resource allocation failures.  My hope 
is that finding more space will fix most of them.  Assuming this patch 
doesn't have any dependencies, I can put it in my linux-next branch.

Also, TJ was working on something similar; any comments TJ?

Thanks,
Jesse
