Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbYDQRMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbYDQRMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbYDQRMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:12:37 -0400
Received: from sous-sol.org ([216.99.217.87]:48755 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507AbYDQRMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:12:36 -0400
Date: Thu, 17 Apr 2008 10:09:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Linux-acpi@vger.kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: pnpacpi: reduce printk severity for "pnpacpi: exceeded the max
	number of ..."
Message-ID: <20080417170939.GD17220@sequoia.sous-sol.org>
References: <20080417010122.148289106@sous-sol.org> <20080417010359.629397865@sous-sol.org> <20080417152405.GB14206@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417152405.GB14206@tull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Andrew (nick@nick-andrew.net) wrote:
> On Wed, Apr 16, 2008 at 06:02:20PM -0700, Chris Wright wrote:
> > -		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> > +		printk(KERN_WARNING "pnpacpi: exceeded the max number of IRQ "
> >  				"resources: %d \n", PNP_MAX_IRQ);
> 
> This is a good time to delete that whitespace before the newline
> in this hunk plus the two following. Unless you're going to go to
> dynamic memory allocation for these arrays in a month and wipe
> out all this code.

Not for -stable...maybe upstream, send Len a patch.
