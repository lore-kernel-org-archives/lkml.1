Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZELAdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZELAdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZELAdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:33:44 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58484
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753030AbZELAdn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:33:43 -0400
X-BigFish: VPS-29(z1039oz542N1432R98dR1805M936fJ9371P10d1Izz1202hzzz2dh6bh95n61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic dma-mapping-broken.h
Date: Mon, 11 May 2009 17:33:43 -0700
In-Reply-To: <200905120229.36047.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic dma-mapping-broken.h
Thread-Index: AcnSmMhdBb0TCwE4T4Oiq3KLMxceuQAACUcA
References: <20090511232019.927138561@arndb.de> <20090511232345.859696820@arndb.de>> <20090511235954.A1CD414D0050@mail215-wa4.bigfish.com> <200905120229.36047.arnd@arndb.de>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: "Arnd Bergmann" <arnd@arndb.de>
CC: <microblaze-uclinux@itee.uq.edu.au>, "Michal Simek" <monstr@monstr.eu>,
       <linux-kernel@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
X-OriginalArrivalTime: 12 May 2009 00:33:41.0025 (UTC) FILETIME=[4C647110:01C9D299]
Message-ID: <20090512003341.A7B3C290046@mail156-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sounds like a great idea...  That's really all that's necessary for
microblazes with write-through cache anyway.

Steve

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, May 11, 2009 5:30 PM
> To: Stephen Neuendorffer
> Cc: microblaze-uclinux@itee.uq.edu.au; Michal Simek;
linux-kernel@vger.kernel.org; FUJITA Tomonori
> Subject: Re: [microblaze-uclinux] [PATCH 12/12] microblaze: use
generic dma-mapping-broken.h
> 
> On Tuesday 12 May 2009, Stephen Neuendorffer wrote:
> >
> > Gah... considering the ll_temac needs this, it should get
implemented
> > ASAP...
> > (Yeah, I know... just not enough hours in the day.)
> >
> 
> FUJITA Tomonori has just posted an asm-generic version of
dma-mapping.h,
> which is half complete. For microblaze, it should be easy to add the
> missing functions, basically falling back on get_free_pages for all
> allocations and on page_to_phys for the actual mapping, as in
> arch/powerpc/kernel/dma.c.
> 
> 	Arnd <><


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


