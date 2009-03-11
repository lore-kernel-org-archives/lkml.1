Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZCKX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZCKX32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 19:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZCKX3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 19:29:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22837 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZCKX3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 19:29:18 -0400
X-IronPort-AV: E=Sophos;i="4.38,346,1233550800"; 
   d="scan'208";a="67748461"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
Date: Wed, 11 Mar 2009 19:42:49 -0400
User-Agent: KMail/1.9.5
CC: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <87a5b0800903110738h508aae87y7fc462d30cc89c7f@mail.gmail.com> <200903111600.05835.wolfgang.mues@auerswald.de> <87a5b0800903110803k5e8a8ee4m50c572d845a38cb0@mail.gmail.com>
In-Reply-To: <87a5b0800903110803k5e8a8ee4m50c572d845a38cb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200903111942.49341.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 11 Mar 2009 23:29:15.0803 (UTC) FILETIME=[31579EB0:01C9A2A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11 Mar 2009 11:03, Will Newton pondered:
> On Wed, Mar 11, 2009 at 3:00 PM, Wolfgang Mües
> <wolfgang.mues@auerswald.de> wrote:
> > Will,
> >
> > Am Mittwoch, 11. März 2009 schrieb Will Newton:
> >> Are they using the same host controller? Have you tried these cards
> >> with a different host controller?
> >
> > I have tried with 3 different spi host controllers.
> >
> >> Are you clocking them particularly slow or fast?
> >
> > 400 KHz, 20 MHz and 25 MHz.
> >
> >> A logic probe may not display any signal integrity issues you might have.
> >
> > My "logic probe" is a 1 GHz leCroy DSO.
> >
> > I am doing this for money, and I am no amateur.
> 
> Ok, sure, but these are things that are best put in your changleogs so
> people can understand what hardware is problematic and how it is
> proven.
> 
> I have not seen these problems or seen them reported by others.
> Hopefully they will speak up and confirm your results.

We have seen the same issues, and have had various Blackfin users report the 
same with a select number of cards. (including Kingston cards that Wolfgang 
referenced).

A few (who also had ARM platforms) said they saw the same on different SPI 
controllers - so I don't think it is a Blackfin specific issue.

-Robin
