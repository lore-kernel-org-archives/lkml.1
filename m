Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYHOM6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYHOM6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHOM5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:57:50 -0400
Received: from mail13.ca.com ([141.202.248.42]:9327 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbYHOM5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:57:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforonaccess scanning
Date: Fri, 15 Aug 2008 08:57:48 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BF5@USILMS12.ca.com>
In-Reply-To: <20080815113528.GI13048@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforonaccess scanning
Thread-Index: Acj+yxFfIDePTtmuT4mJWS5O72z+fgACdAMw
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <20080815093513.5ca24c26@lxorguk.ukuu.org.uk> <20080815113528.GI13048@mit.edu>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Theodore Tso" <tytso@mit.edu>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Rik van Riel" <riel@redhat.com>, "Pavel Machek" <pavel@suse.cz>,
       <davecb@sun.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 15 Aug 2008 12:57:48.0277 (UTC) FILETIME=[84B1F250:01C8FED6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Theodore Tso [mailto:tytso@mit.edu]
> Sent: Friday, August 15, 2008 7:35 AM
> To: Alan Cox
> Cc: Rik van Riel; Pavel Machek; Press, Jonathan; davecb@sun.com;
Adrian Bunk;
> Mihai Don??u; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-
> security-module@vger.kernel.org; Arjan van de Ven
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
alinuxinterfaceforonaccess
> scanning
> 
> On Fri, Aug 15, 2008 at 09:35:13AM +0100, Alan Cox wrote:
> > We shouldn't need to care what people do with good interface. What
> > matters is in your airport example is that at the infrastructure
level
> > there is a point you can choose to do scanning and we agree where.
> > Whether people use this to provide a Starbucks or goons with rubber
> > gloves who take away babies milk is an application layer problem.

An interesting example is (please don't scream everyone -- it's just an
illustration of one approach to the problem) NetWare.  (In fact, we
still have a lot of active NetWare customers, so the fact that it is an
archaic OS is not really the issue.)  NetWare takes the kitchen-sink
approach.  It has an interface that allows notification on a whole host
of i/o events, way more than we have ever found useful, and the
application can register for the ones it wants and go from there.  The
kernel does not care what the application's inherent logic is, as long
as the application passes control back with some appropriate return
information (in other words, allow or deny in the context of malware)
within a reasonable amount of time.  I have no idea what purpose it was
written for originally, and there are flaws to be sure, but I know that
it is used successfully for HSMs and anti-malware products.  


> If it's a good interface that also happens to address HSM/DMAPI
> functionality, as well as a more efficient way for trackerd to work, I
> agree completely.  I think you will agree the proposed TALPA interface
> is a bit too virus-scanner specific, though?  Especially with explicit
> talk of specialized (persistent or not) "clean/dirty/infected" bits
> that the kernel would store in the inode for the benefit of the AV
> scanner?  That's rather optimized for the goons-with-rubber-gloves
> that-make-mothers-drink-their-own-breast-to-prove-it's-not-explosives
> crowd, I think...

That may just be a question of terminology.  If the bits are construed
not as clean/dirty/infected, but as "I care about this file" vs. "I
don't care about this file" then the rubber gloves come off.


Jon Press

