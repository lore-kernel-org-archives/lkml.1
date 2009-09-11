Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZIKWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZIKWRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZIKWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:17:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996AbZIKWRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:17:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH 7/9] PM: Measure device suspend and resume times
Date: Sat, 12 Sep 2009 00:18:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200909100127.11252.rjw@sisk.pl> <200909100139.21954.rjw@sisk.pl> <20090911174831.GA11467@ben-laptop>
In-Reply-To: <20090911174831.GA11467@ben-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909120018.23375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, Ben Gamari wrote:
> On Thu, Sep 10, 2009 at 01:39:21AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Measure and print the time of suspending and resuming all devices.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Do you have any rough numbers describing actual suspend/resume times
> before and after this patch set?  Of what order of magnitude is the
> improvement on standard x86 hardware? Just curious.

Depending on the system on which it's run, it gives up to 15% speedup,
but please note that only PCI and ACPI devices are now allowed to
suspend/resume asynchronously, while on my test systems the most significant
stalls are from USB, serio devices and (SATA) drives which are still
suspended/resumed synchronously.

Thanks,
Rafael
