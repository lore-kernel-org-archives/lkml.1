Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYA1WFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYA1WFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYA1WFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:05:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbYA1WFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:05:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 23:02:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801282150.15411.rjw@sisk.pl> <479E4918.3010204@zytor.com>
In-Reply-To: <479E4918.3010204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282302.51796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > On Monday, 28 of January 2008, Jeremy Fitzhardinge wrote:
> >> Rafael J. Wysocki wrote:
> >>> Actually, no.  We only do that with the kernel code mapping which should be
> >>> safe as long as TLBs are not flushed (and they aren't).
> >>>   
> >> Er, what?  Assuming the TLB will retain some mappings while you 
> >> overwrite the pagetable is a highly dubious prospect.  Are you copying 
> >> the same values over, or something else?
> > 
> > As long as a relocatable kernel is not used to restore a non-relocatable one
> > (or vice versa), we're copying the same values over.
> > 
> 
> So that case is deliberately considered broken?

Not deliberately, but the fix I had caused a regression.  It's just a pending
issue.

Rafael
