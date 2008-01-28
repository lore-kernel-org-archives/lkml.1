Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYA1Uwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYA1Uwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYA1Uw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:52:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36772 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYA1Uw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:52:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 21:50:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801282126.45751.rjw@sisk.pl> <479E3EC6.5070800@goop.org>
In-Reply-To: <479E3EC6.5070800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282150.15411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Jeremy Fitzhardinge wrote:
> Rafael J. Wysocki wrote:
> > Actually, no.  We only do that with the kernel code mapping which should be
> > safe as long as TLBs are not flushed (and they aren't).
> >   
> 
> Er, what?  Assuming the TLB will retain some mappings while you 
> overwrite the pagetable is a highly dubious prospect.  Are you copying 
> the same values over, or something else?

As long as a relocatable kernel is not used to restore a non-relocatable one
(or vice versa), we're copying the same values over.

Rafael
