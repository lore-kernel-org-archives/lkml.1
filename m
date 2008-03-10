Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYCJNuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYCJNuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYCJNuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:50:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:41995 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYCJNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=RmcSgu0733WyQCQQ+JNW7BYOrfHZCJuUWJbr2rmXNbjpKW84UZHms7lve0D4s0Zv44pbpDzkOTb1Fxujz990/HnXCkx3Nk5o/klNsPMBZICFmp0nwqV3KRdnNDa2ZcL320HkAVPfbJ7nIHVNs9AyOCRZQdELBA3fRKyK8h8V6/k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Date: Mon, 10 Mar 2008 15:04:17 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <200803101410.27877.rjw@sisk.pl>
In-Reply-To: <200803101410.27877.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803101504.17219.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008, Rafael J. Wysocki wrote:
> On Monday, 10 of March 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 10 March 2008, Anders Eriksson wrote:
> > > 
> > > aeriksson@fastmail.fm said:
> > > > torvalds@linux-foundation.org said:
> > > >> I think we do want the bisect run here.
> > > >> My worry is that this is likely very timing-sensitive, so when it starts
> > > >> failing it might not be because of the commit that actually introduces the
> > > >> bug, but because some other timing changed, but with some luck that won't  
> > > >> be the case.
> > > 
> > > > I'm on it. Slow machine. Household's router, 4000 versions to go... 
> > > 
> > > The bisect came up with this:
> > > 
> > > 18a056feccabdfa9764016a615121b194828bc72 is first bad commit
> > > commit 18a056feccabdfa9764016a615121b194828bc72
> > 
> > Hmm, this is the first commit _after_ the previous "guilty"
> > commit 852738f39258deafb3d89c187cb1a4050820d555 so it just
> > can't be the "real bad" one...
> 
> Well, would that be practical to prepare a patch reverting this commit
> and whatever depends on it so that Anders can verify it?

We've already verified that 8527 just makes the problem more likely
to occur (the discussion is in the earlier "-rc3 regression" thread)
so reverting 8527 or 18a0 won't really help.

Thanks,
Bart
