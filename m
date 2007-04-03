Return-Path: <linux-kernel-owner+w=401wt.eu-S966150AbXDCKtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966150AbXDCKtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966156AbXDCKtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:49:33 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:3695 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966150AbXDCKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:49:32 -0400
Date: Tue, 3 Apr 2007 12:51:39 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
Message-ID: <20070403125139.3d610c1c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200704031126.52750.ak@suse.de>
References: <4611652F.700@zytor.com>
	<200704031030.36473.ak@suse.de>
	<20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
	<200704031126.52750.ak@suse.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 11:26:52 +0200,
Andi Kleen <ak@suse.de> wrote:

> > 
> > On s390, it would be more than strangeness. There's no implementation
> > of PCI at all, someone would have to cook it up - and it wouldn't have
> > any use beyond those special devices. Since there isn't any bus type
> > that is available on *all* architectures, a generic "virtual" bus with
> > very simple probing seems much saner...
> 
> You just have to change all the distribution installers then. 
> Ok I suppose on s390 that's not that big issue because there are not
> that many for s390. But for x86 there exist quite a lot. I suppose
> it's easier to change it in the kernel.

Huh? I don't follow you here. Why should this be easier for s390 vs.
x86? (And since there seems to be a trend to use HAL as a device
discovery tool recently: A new bus type is easy enough to add there.)

And I really think we should have a clean design in the kernel instead
of trying to wedge virtual devices into a known system. Exposing
virtual devices (which may be handled totally differently) as PCI
devices just seems hackish to me.
