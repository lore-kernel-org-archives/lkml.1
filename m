Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbYKVM5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbYKVM5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbYKVM4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:56:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbYKVM4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:56:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Date: Sat, 22 Nov 2008 13:56:07 +0100
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
References: <200810142254.07024.rjw@sisk.pl> <200810152320.06167.rjw@sisk.pl> <200811221111.50952.carlos@strangeworlds.co.uk>
In-Reply-To: <200811221111.50952.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811221356.08294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of November 2008, Carlos Corbacho wrote:
> On Wednesday 15 October 2008 22:20:05 Rafael J. Wysocki wrote:
> > > > IOW, we aren't doing anything wrong and the BIOS is buggy.
> > >
> > > So how does Windows cope with this?
> >
> > I don't know. :-(
> >
> > One possible explanation is that the device causing the trouble is not put
> > into D3 at all during suspend, but I'm speculating here.
> 
> Do we know which device it is that causes the trouble on this HP box?

Not really, but most probably is one of the USB controllers.  Hopefully, we'll
find out.

Thanks,
Rafael
