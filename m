Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYGOWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYGOWyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYGOWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:54:09 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:38366 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752697AbYGOWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:54:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=DwicYfQRFziUHGmlPqM1Wqt/hqe3zGCb3alke0Rs0kx6t5IEtloA+8LszgZn9BD0mORxqBfmtwxAjMB7QLHf2kbwaDMPWB/gBmt/qiYsTGqLI8EGjnSdcnywKh+ZP1dI;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akataria@vmware.com
Subject: Re: acpi based pci gap calculation  - v3
Date: Tue, 15 Jul 2008 15:53:39 -0700
User-Agent: KMail/1.9.9
Cc: "ak@linux.intel.com" <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
References: <1216148382.6135.21.camel@alok-dev1> <200807151328.00739.jbarnes@virtuousgeek.org> <1216155256.6135.25.camel@alok-dev1>
In-Reply-To: <1216155256.6135.25.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151553.41403.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2008 1:54 pm Alok Kataria wrote:
> I have tested it with couple of different BIOS settings and it seems to
> work as it should.
>
> > Most of the PCI bugs we
> > have at the moment are related to PCI resource allocation failures.  My
> > hope is that finding more space will fix most of them.  Assuming this
> > patch doesn't have any dependencies, I can put it in my linux-next
> > branch.
>
> No dependencies, I had added a function e820_search_gap which is used by
> this patch. This function is already in the mainline tree.
> Thanks for applying.

Ok, I stuffed it in my linux-next branch.  I'll let it sit there for a day or 
so though, just to shake out any build problems etc. in linux-next before 
asking Linus to pull the whole lot.

Thanks,
Jesse
