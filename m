Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbXIEQzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbXIEQzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXIEQy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:54:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:43931 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbXIEQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iqsw/T85gxjpvqtv226YZgKqwJ9bXZnOtUgY/F76MY3ipn2Q4f8t2c8weQ4ehU6a8xg550Li0LLxZcxtsLcsmUXJGsPPAxnzdzdu0RtGEUnKIzDRFUtRPA+dCFHlZBnW6Z/t9btqjTsPjRGIQkilio++s1WWOVcsAyC/PO9L+lY=
Message-ID: <6d4bc9fc0709050954p5c769864q1088310c0a70061b@mail.gmail.com>
Date: Wed, 5 Sep 2007 18:54:52 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, linux-ide@vger.kernel.org
In-Reply-To: <20070905094845.1d2f84cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no>
	 <46CF68C4.9040506@shaw.ca>
	 <6d4bc9fc0708250637g10c75f44x20ae1533874c986a@mail.gmail.com>
	 <Pine.LNX.4.64.0708281515340.3018@fbirervta.pbzchgretzou.qr>
	 <6d4bc9fc0708280706q278fe285kdf90a27f40d2a55@mail.gmail.com>
	 <20070905094845.1d2f84cb.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At this point it safe to say that it was a cable related issue.

I swapped it to be sure and i haven't had issues since.

Sincerely,

Maarten Maathuis.

On 9/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 28 Aug 2007 16:06:41 +0200 "Maarten Maathuis" <madman2003@gmail.com> wrote:
> > I have not had any issues, i swapped the cable because a while ago i
> > had to check the connection of the drive after the bios failed to
> > detect the drive. That is why i considered that a posibility. Kernel
> > 2.6.18 does not have NCQ support for nvidia chipsets, so that cannot
> > be it.
> >
> > Maarten.
> >
> > On 8/28/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > >
> > > On Aug 25 2007 15:37, Maarten Maathuis wrote:
> > > >
> > > >A broken cable seems like a realistic possibility, so i swapped it for
> > > >another cable. I will try if that solves the problem.
> > >
> > > Hi, did you have any success/failure, other updates?
> > > I am facing a similar problem (just posted to linux-ide@vger.kernel.org),
> > > but also with 2.6.18, and it does not look like an NCQ or loose cable problem (got a
> > > backplane, and sda is working normal).
> > >
>
> This is a rather comedic email thread, with people top-posting, others
> leaving others off the cc list, Robert's MUA reliably and inexplicably
> mangling both In-Reply-To: and References: thus breaking threading, no
> visible sign of how Jan got involved and no linux-ide cc's.
>
> Enough time has passed for everyone to forget all about this.  So Maarten,
> if you still believe that this is still a kernel bug then please update us
> on its status and provide a full description for linux-ide..  Please use
> reply-to-all for that.
>
> Thanks.
>
