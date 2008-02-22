Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbYBVTZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbYBVTZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYBVTZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:25:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3031 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758299AbYBVTZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:25:38 -0500
Date: Fri, 22 Feb 2008 20:25:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080222192526.GF6060@ucw.cz>
References: <47BDEF36.8000903@goop.org> <1203631956.28436.4.camel@cthulhu.hellion.org.uk> <47BDF9C7.6040400@zytor.com> <47BE0017.1020205@goop.org> <47BE0228.7020204@zytor.com> <1203665106.28436.19.camel@cthulhu.hellion.org.uk> <20080222092855.6ace8845@core> <47BE9C18.5060202@firstfloor.org> <20080222100034.1e78d661@core> <47BEA0DF.9070800@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BEA0DF.9070800@firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-22 11:15:59, Andi Kleen wrote:
> Alan Cox wrote:
> >> Actually I switched 64bit over to trust e820 completely and not
> >> reserve 640k-1MB explicitly some time ago
> >> and AFAIK there hasn't been any reports that it causes problems.
> >>
> >> So presumably trusting e802 is ok on modern systems (2003+)
> > 
> > Apparently so - at least 64bit capable ones. 
> 
> They should all use the same BIOS code bases, except perhaps

At least kohjinsha subnotebook has very 'interesting' bios. Very new,
but geode -> not 64bit.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
