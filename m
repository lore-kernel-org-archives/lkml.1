Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYHDFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYHDFfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYHDFfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:35:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:53685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYHDFfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:35:22 -0400
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
	and IDE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080803173941.314edf33@lxorguk.ukuu.org.uk>
References: <1217779055.4179.10.camel@localhost.localdomain>
	 <20080803173941.314edf33@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 15:35:04 +1000
Message-Id: <1217828104.24157.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 17:39 +0100, Alan Cox wrote:
> On Sun, 03 Aug 2008 10:57:35 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> - For PC class hardware libata covers everything in old IDE and a lot
> more.
> - For the older Mac hardware libata does not have pre PCI Macintosh
> support although it is in progress
> - For certain embedded PPC boards there are some things to sort out with
> IRQ routing on non standards sane configurations using pata_ali in
> particular.
> 
> There is a trend in new hardware to interfaces that simply won't fit old
> IDE so that process of libata only drivers is likely to continue.

Actually, libata is missing anything using the Apple proprietary (I call
it "macio") IDE controller. That includes pretty much all Macs with IDE
not only pre-PCI. IE, it's used for the CD-ROM on the G5's for example
(the disks use sata_svw).

I'm working on it though :-)

> Won't be at KS and I suspect that is true of most of the folks hacking on
> both sets so the right place for discussion would be the net. Right now
> the PPC bits need fixing, and the lack of libata Macio support for the
> moment makes the debate premature.

Hopefully that will be fixed by .28

Cheers,
Ben.


