Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXDCJPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXDCJPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933590AbXDCJPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:15:25 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:24828 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318AbXDCJPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:15:25 -0400
Date: Tue, 3 Apr 2007 11:17:31 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
Message-ID: <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200704031030.36473.ak@suse.de>
References: <4611652F.700@zytor.com>
	<200704022312.39195.ak@suse.de>
	<200704031029.06819.borntrae@de.ibm.com>
	<200704031030.36473.ak@suse.de>
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

On Tue, 3 Apr 2007 10:30:36 +0200,
Andi Kleen <ak@suse.de> wrote:

> On Tuesday 03 April 2007 10:29:06 Christian Borntraeger wrote:
> > On Monday 02 April 2007 23:12, Andi Kleen wrote:
> > > 
> > > > How would that work in the case where virtualized guests don't have a
> > > > visible PCI bus, and the virtual environment doesn't pretend to emulate
> > > > a PCI bus?
> > > 
> > > If they emulated one with the appropiate device 
> > > then distribution driver auto probing would just work transparently for
> > > them. 
> > 
> > Still, that would only make sense for virtualized platforms that usually have 
> > a PCI bus. Thinking about seeing a PCI device on ,lets say, s390 is strange.
> 
> If it gets the job done surely you can tolerate a little strangeness?

On s390, it would be more than strangeness. There's no implementation
of PCI at all, someone would have to cook it up - and it wouldn't have
any use beyond those special devices. Since there isn't any bus type
that is available on *all* architectures, a generic "virtual" bus with
very simple probing seems much saner...
