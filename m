Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbXHFC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbXHFC0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXHFC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:26:13 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:20789 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXHFC0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LWQY8q66DwiPbQzGhosgF/8CHqyVwloaGY3pZ3vQth4zZCSIgunY02k77VZ+LQVi9BgBwUBCp/RT/vHdGMNhAM/mjKyEAP2OSDc9Meifx9khQtpvF/8fJ+mXz6KmESUYmMCwIzv3YuspP/Umpt1yEkp0/W0phSf95m7bF9Ns+q8=
Message-ID: <8bd0f97a0708051926l63718982l4c991aebd817c94b@mail.gmail.com>
Date: Sun, 5 Aug 2007 22:26:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1186366246.5609.4.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186318969.16030.2.camel@roc-laptop>
	 <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
	 <1186366246.5609.4.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> On Sun, 2007-08-05 at 22:04 -0400, Mike Frysinger wrote:
> > On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > Bryan Wu (4):
> > >       Blackfin SPI driver: Initial supporting BF54x in SPI driver
> > >
> > > Michael Hennerich (11):
> > >       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
> > >       Blackfin arch: add peripheral resource allocation support
> > >       Blackfin arch: Add label to call new GPIO API
> > >       Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
> > >       Blackfin SPI driver: use new GPIO API and add error handling
> >
> > i think this is the sort of thing Linus wants left for initial merge windows ?
> > -mike
>
> Actually, this GPIO API has been added to the upstream in -RC1. In this
> pull, Michael's patch just enable it in arch code and driver. And it is
> tested at least 2-3 weeks, I think it is OK for the -RC merge.
>
> And most our driver things are moved to depend on this new GPIO API. I
> just wanna make thing easier to maintain.

i was referring to the SPI stuff, not GPIO
-mike
