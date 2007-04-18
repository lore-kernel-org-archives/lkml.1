Return-Path: <linux-kernel-owner+w=401wt.eu-S1030961AbXDRAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030961AbXDRAhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030966AbXDRAhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:37:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030957AbXDRAhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:37:35 -0400
Date: Tue, 17 Apr 2007 20:35:21 -0400
From: Dave Jones <davej@redhat.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070418003521.GA20566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <20070416005446.GB21217@redhat.com> <20070416011636.GO3691@stusta.de> <20070416062921.GB7528@redhat.com> <1176706447.5129.6.camel@daplas> <20070416072326.GA15281@redhat.com> <1176708722.5129.8.camel@daplas> <20070416075543.GB15281@redhat.com> <1176715603.6794.13.camel@localhost.localdomain> <20070417033400.GE22804@redhat.com> <1176853735.8463.9.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176853735.8463.9.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:48:55AM +0800, Antonino A. Daplas wrote:

 > > When the backlight doesn't come on, for some reason, nothing else
 > > runs.  Capslock works, so it's at least partially alive, but even
 > > doing..
 > > 
 > > echo mem > /sys/power/state ; echo foo >/bar ; sync
 > > 
 > > results in no /bar being created.
 > > Ethernet remains down when its in this state too.
 > 
 > Have you tried these boot options?
 > 
 > acpi_sleep=s3_mode; or
 > acpi_sleep=s3_bios,s3_mode

Yeah, did nothing. I also tried acpi_sleep=s3_bios on its own.

	Dave

-- 
http://www.codemonkey.org.uk
