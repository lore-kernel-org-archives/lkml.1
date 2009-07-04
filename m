Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZGDV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZGDV2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 17:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGDV2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 17:28:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZGDV2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 17:28:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael Witten" <mfwitten@gmail.com>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Date: Sat, 4 Jul 2009 23:29:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: "Johannes Stezenbach" <js@sig21.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cNOy0-5C5-23@gated-at.bofh.it> <cNOok-5pJ-11@gated-at.bofh.it> <4a4f9af3.27015a0a.48c6.ffffa6d5@mx.google.com>
In-Reply-To: <4a4f9af3.27015a0a.48c6.ffffa6d5@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907042329.04926.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 July 2009, Michael Witten wrote:
> On Tue, 16 Jun 2009 23:39:59 +0200, Rafael J. Wysocki wrote
> (http://www.spinics.net/lists/linux-acpi/msg22661.html):
> 
> > In fact, we need to do this entire thing differently.
> > 
> > The basic problem is that cpufreq_suspend() is a sysdev thing, so it will 
> > always be called with iterrupts off and *only* for CPU0.  So, it looks like
> > the majority of things we do there is just unnecessary (at least).
> 
> What's the status? This bug is driving me nuts.

Unfortunately, still unresolved.

Rafael
