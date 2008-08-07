Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYHGQrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYHGQrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHGQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:47:45 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:39571 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752684AbYHGQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:47:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=QX2FoJEAUKD2xmmCwZGdsrgtnLQx7tM9t7gW/YF1OTfrj4JeA2YidICpZ4RXKSRCjLn2J3y+vphINemwlMgDshTtEFk2pqryleAcsg9sa/EOMcxhdR1Uj9uffiL5xZ2v;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: "e100_probe: Error clearing wake event" when booting 2.6.27-rc1
Date: Thu, 7 Aug 2008 09:47:37 -0700
User-Agent: KMail/1.9.9
Cc: Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808051730.27599.alessandro.guido@gmail.com> <200808052203.07815.rjw@sisk.pl>
In-Reply-To: <200808052203.07815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070947.37534.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 5, 2008 1:03 pm Rafael J. Wysocki wrote:
> On Tuesday, 5 of August 2008, Alessandro Guido wrote:
> > [please cc me on replies]
> >
> > I'm getting this error message when booting my laptop.
> >
> > The commit that causes this is:
> >
> > commit eb9d0fe40e313c0a74115ef456a2e43a6c8da72f
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Mon Jul 7 03:34:48 2008 +0200
> >
> >     PCI ACPI: Rework PCI handling of wake-up
> >
> > [very long commit message snipped]
> >
> > Should I ignore that?
>
> The message is harmless, but it exposes the problem that e100_probe()
> should not use pci_enable_wake() for this purpose.
>
> The appended patch makes it use pci_pme_active() instead.

I can take the pci_pme_active bits, but the e100 stuff should go in through 
Jeff probably.  Care to respin?

Thanks,
Jesse
