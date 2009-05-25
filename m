Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZEYXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZEYXPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZEYXPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:15:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55272 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZEYXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=i4FImOb1vlGrj1CFowQKdE40V6x5Gg+ytV075+nLasloFVJWUdMggT13nyanibDkot
         SjKbPFgzadUHRvXMpgu7W8NB6n+sXBkJrWA8qP5Ob5p/9Srw+/tlv92H4ivLjBbHu5+t
         SfUoMgN+pb06+WC21tsLBv+2Lt9iSBP9fJpak=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
Date: Tue, 26 May 2009 01:19:56 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Richard Atterer <richard@2009.atterer.net>, linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <20090525171305.GA5855@arbonne.lan> <200905260111.40728.rjw@sisk.pl>
In-Reply-To: <200905260111.40728.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260119.57542.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 01:11:40 Rafael J. Wysocki wrote:
> On Monday 25 May 2009, Richard Atterer wrote:
> > On Mon, May 25, 2009 at 04:30:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > Hmm, we added ACPI NVS memory handling there and some machines seem
> > > to have trouble with it.  I think it would be worth to check it first.
> > > 
> > > Richard, could you try s2disk on some recent 2.6.30-rc kernel while
> > > booting using "acpi_sleep=s4_nonvs"?
> > 
> > I just tried that with 2.6.30-rc7, unfortunately it doesn't make any 
> > difference.
> > 
> > It turns out that if I wait long enough (just over 1 minute) both during 
> > suspend and resume, I *am* able to suspend and resume the machine. I have 
> > to manually turn it off or reset it though.
> > 
> > Another possibly interesting observation: My DVD writer apparently gets 
> > reset before the 1-minute hang and my USB hub after the hang.
> 
> You replied to Jeff that hibernation worked with CONFIG_IDE=n.  What was wrong
> with that test?

It didn't work.  That was wrong.

Please at least read the current thread before asking such questions.
