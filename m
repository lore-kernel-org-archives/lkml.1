Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYBLW3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYBLW3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYBLW3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:29:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYBLW3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:29:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9944] suspend to ram doesn't work anymore on Thinkpad T61 with Intel X3100
Date: Tue, 12 Feb 2008 23:27:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bugme-daemon@bugzilla.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080212221423.7F88B108017@picon.linux-foundation.org>
In-Reply-To: <20080212221423.7F88B108017@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122327.59656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of February 2008, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9944
> 
>
> > Distribution: Debian Sid
> > Hardware Environment: Thinkpad T61
> > Software Environment: 
> > Problem Description:
> > 
> > Suspend to ram doesn't work anymore on my thinkpad t61 with 2.6.25-rc1. On
> > 2.6.24 I had to pass acpi_sleep=s3bios at boot time and suspend with s2ram -f
> > -a 3.
> > 
> > On 2.6.25-rc1 doing (on console, with X not running) that leads to a blank
> > screen and the ___sleep___ led (the moon) on the thinkpad blinks (like when it
> > is currently suspending), but nothing happens then.
> > 
> > If I can make some more tests, or if you need more info, please ask. I hope
> > this is no duplicate.
> > 
> 
> I have a t61p and suspend/hibernate is bad and deteriorating.  So
> many things go wrong that I'm afraid to test it any more.

There are at least two known suspend regressions, one of which affects the T61
for sure.  There's a fix for it, available at:
http://lkml.org/lkml/2008/2/11/472

The fix for the second issue is in the works.
