Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbXCTPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbXCTPUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbXCTPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:20:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:45951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbXCTPUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:20:50 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: s2ram autowake regression is still there in 2.6.21-rc4-git
Date: Tue, 20 Mar 2007 11:19:22 -0400
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20070320115657.GA4438@elf.ucw.cz> <20070320120650.GA2578@elf.ucw.cz>
In-Reply-To: <20070320120650.GA2578@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703201119.22468.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007 08:06, Pavel Machek wrote:
> Hi!
> 
> > Run this script. The s2ram at the end of it will wakeup immediately
> > after going to sleep, bad. I tried reproducing it with smaller
> > version, but was not too successful.
> 
> Actually
> 
> > sleep 2
> > echo -n "testing swsusp (platform)..."
> > echo platform > /sys/power/disk
> > echo disk > /sys/power/state
> > echo "okay"
> > 
> > sleep 2
> > echo -n "testing s2ram..."
> > s2ram
> > echo "okay"
> 
> ...this is enough to trigger it. I've done my testing on x60, FWIW.

Please try the consolidated ACPI patch that is currently staged for release to upstream:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21-rc4.diff.gz
comming soon to a mirror near you:-)

thanks,
-Len
