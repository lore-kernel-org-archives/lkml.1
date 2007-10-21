Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXJUKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXJUKJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXJUKJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:09:30 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:25877 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXJUKJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:09:29 -0400
Date: Sun, 21 Oct 2007 12:09:26 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: emist <emistz@gmail.com>
Cc: Linux <linux-kernel@vger.kernel.org>,
       Gerald Schaefer <geraldsc@de.ibm.com>, Carsten Otte <cotte@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] Bug fix for the s390 dcssblk driver
Message-ID: <20071021100926.GA4420@osiris.ibm.com>
References: <200710201451.57138.elendil@planet.nl> <471A39D2.1070303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471A39D2.1070303@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 01:24:34PM -0400, emist wrote:
> Frans Pop wrote:
> > emist wrote:
> >> The following patch fixes and issue in the s390 dcssblk driver. The
> >> issue is caused when an unsuccessful attempt is made in order to change
> >> a segment's type through the device attribute file "shared". This causes
> >> the driver to remove the device in question, removing with it the device
> >> attribute which is currently handling the call. The result is a hang on
> >> the driver as it removes memory from under its feet.
> >>
> >> Not exactly sure if this explanation makes sense or its entirely
> >> accurate. This is what I believe at this point from encountering and
> >> fixing the error. Anyway here is the patch, hope it helps.
> > 
> > Hi,
> > 
> > If you don't get any reactions to your patch during the next few days, I 
> > suggest you resend it and then CC the linux-s390@vger.kernel.org list and 
> > possibly also the maintainer at linux390@de.ibm.com.
> > 
> > In general you should always try to CC the relevant list/people as listed in 
> > the MAINTAINERS file and not just the linux-kernel list, both for patches 
> > and when reporting problems.
> > 
> > Cheers,
> > Frans Pop
> > 
> 
> Thanks Frans, I will do as you suggest.
> 
> Have a good one,
> 
> Igor H.

Gerald or Carsten (cc'ed) should look into this.
Thanks for reporting.
