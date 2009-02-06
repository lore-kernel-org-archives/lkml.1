Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZBFPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZBFPBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZBFPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:01:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:55429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbZBFPBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:01:33 -0500
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, ralf@linux-mips.org, dhowells@redhat.com,
       matthew@wil.cx, chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090206145119.GB13758@n2100.arm.linux.org.uk>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
	 <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
	 <20090205191907.GA27422@elte.hu>
	 <1233886017.3463.26.camel@localhost.localdomain>
	 <20090206022025.GA8317@elte.hu>
	 <1233929922.3209.6.camel@localhost.localdomain>
	 <20090206142134.GA13758@n2100.arm.linux.org.uk>
	 <1233930860.3209.13.camel@localhost.localdomain>
	 <20090206145119.GB13758@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 20:30:07 +0530
Message-Id: <1233932407.3209.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 14:51 +0000, Russell King - ARM Linux wrote:
> > > 
> > > So no point including this file in assembly with this patch - the ifndef
> > > disables the entire file.
> > 
> > Truth Table of linux/types.h :
> > 
> > If Assembly then N
> > otherwise Y
> > 
> > what your table says.
> 
> If the entire file is not suitable for assembly, don't include the file
> in assembly files.  Nice and simple, and no need to add additional ifdefs.

Ahh, so your truth table says:

If Assembly then make different header files
If C then make another header files

Do not you think your truth table is complex and very difficult to
handle and maintain ?

Can we make things simple and easier.

Thanks,
--
JSR


