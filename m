Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXDCKjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXDCKjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXDCKjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:39:03 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:10408 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965620AbXDCKjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:39:01 -0400
Date: Tue, 3 Apr 2007 12:41:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
Message-ID: <20070403124108.06108665@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200704031141.50045.arnd@arndb.de>
References: <4611652F.700@zytor.com>
	<461178D9.402@goop.org>
	<46117F72.6020506@zytor.com>
	<200704031141.50045.arnd@arndb.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 11:41:49 +0200,
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 03 April 2007, H. Peter Anvin wrote:
> > However, one probably wants to think about what the heck one actually 
> > means with "virtualization" in the absence of a lot of this stuff.  PCI 
> > is probably the closest thing we have to a lowest common denominator for 
> > device detection.
> 
> I think that's true outside of s390, but a standardized virtual device
> interface should be able to work there as well. Interestingly, the
> s390 channel I/O also uses two 16 bit numbers to identify a device
> (type and model), just like PCI or USB, so in that light, we might
> be able to use the same number space for something entirely different
> depending on the virtual bus.

Even if we used those ids for cu_type and dev_type, it would still be
ugly IMO. It would be much cleaner to just define a very simple, easy
to implement virtual bus without dragging implementation details for
other types of devices around.
